function xps = resex_build_xps_from_gwf_txt(gwf_txt_A_fn, gwf_txt_B_fn, pause_dur_fn, nii_fn)

%gwf_txt_A_fn: path to part A of gradient waveform
%gwf_txt_B_fn: path to part B of gradient waveform

xps = mdm_xps_from_bval_bvec(nii_fn); %this xps has no gwf info at the moment
% xps = mdm_xps_from_bval_bvec(bval_fn, bvec_fn, b_delta);

%read gwf from txt and add to xps
disp(['Building xps for ', nii_fn,  ' :'])

%get pause time
fileID = fopen(pause_dur_fn);
pause_time = fscanf(fileID, '%f')*1e-6;
fclose(fileID);
disp(['Found pause duration of ' num2str(pause_time*1e6) ' us'])

dt = 1e-4;

%resample parts A and B to finer resolution
gA = readmatrix(gwf_txt_A_fn);
gA = gA(:,1);
tA_coarse = (0:(numel(gA)-1))*1e-3;
tA_fine = 0:dt:max(tA_coarse);
gA = interp1(tA_coarse, gA, tA_fine, 'pchip')';
gA([1 end]) = 0;

gB = readmatrix(gwf_txt_B_fn);
gB = -gB(:,1);
tB_coarse = (0:(numel(gB)-1))*1e-3;
tB_fine = 0:dt:max(tB_coarse);
gB = interp1(tB_coarse, gB, tB_fine,  'pchip')';
gB([1 end]) = 0;
gB = gB*abs(sum(gA)/sum(gB)); %ensure balance

%rf time
t180 = zeros(ceil(pause_time/dt), 1);

%reconstruct 1D waveform
g = [gA; t180; gB];

%compute q and b-value
q = msf_const_gamma*cumsum(g)*dt;
b = sum(q.^2)*dt;
time = (0:(numel(q)-1))*dt;

%compute q4

xps.q4 = cell(xps.n, 1);
xps.time = cell(xps.n, 1);
for c = 1:xps.n
    tmp_b = xps.b(c);
    if tmp_b == 0; continue; end
    tmp_q = q*sqrt(tmp_b/b);
    xps.q4{c} = (1/tmp_b^2)*resex_mc_correlate(tmp_q'.^2, tmp_q'.^2, dt);
    xps.time{c} = time;
end

%compute Gamma and Vomega
[gam, vom] = resex_mc_protocol_to_gamma_vomega(g', dt);
xps.Gamma = ones(xps.n,1)*gam;
xps.Vomega = ones(xps.n,1)*vom;
xps.dt = ones(xps.n,1)*dt;
% xps.time = repmat(time, xps.n, 1);

%check
mdm_xps_check(xps);

%save
xps_fn = mdm_xps_fn_from_nii_fn(nii_fn);
mdm_xps_save(xps, xps_fn);

disp(['Saved xps to ', xps_fn])
end

