function resex_run_fit(s)
%resex data analysis

disp(['Running RESEX fit on data at ' s.nii_fn])

[nii_folder, nii_name, ~] = fileparts(s.nii_fn);
if contains(nii_name, '.nii')
    nii_name = replace(nii_name, '.nii', '');
end
mask_name = [nii_name, '_mask'];

[I, h] = mdm_nii_read(fullfile(nii_folder, strcat(nii_name, '.nii.gz')));
[mask, ~] = mdm_nii_read(fullfile(nii_folder, strcat(mask_name, '.nii.gz')));

I = mio_smooth_4d(I, 0.5);

load(fullfile(nii_folder, strcat(nii_name, '_xps.mat')), 'xps')

%add time to xps
xps.t = 0:xps.dt(1):((size(xps.gwf,2)-1)*xps.dt(1));

% % %begin analysis

[x,y,z,~] = size(I);

num_pars = 4;
pars = NaN(x,y,z,num_pars);

parfor_progress(x);
tic
parfor c_x = 1:x
    tmp_pars = NaN(y,z, num_pars);
    for c_y = 1:y
        for c_z = 1:z
            signal = double(squeeze(I(c_x, c_y, c_z, :)));
            if mask(c_x, c_y, c_z)
                m = resex_gamma_simple_1d_data2fit(signal, xps);
                tmp_pars(c_y, c_z, :) = m;
            end
        end
    end
    pars(c_x, :, :,:) = tmp_pars;
    parfor_progress;
end
parfor_progress(0);
toc

% %build model fit structure: aggregate simple
mkdir(fullfile(nii_folder, 'fit/simple'))
fmt = '.nii.gz';
mfs_folder =  fullfile(nii_folder, 'fit/simple/');
mfs_fn = fullfile(nii_folder, 'fit/simple/mfs');



f =     [    1         1e9         1e18        1];
mfs.s0 = pars(:,:,:,1)*f(1);
mfs.E_D = pars(:,:,:,2)*f(2);
mfs.V = pars(:,:,:,3)*f(3);
mfs.k = pars(:,:,:,4)*f(4);
mdm_mfs_save(mfs, I, mfs_fn);
fig_maps = {'s0', 'E_D',  'V', 'k'};


for c_map = 1:numel(fig_maps)
    I = mfs.(fig_maps{c_map});
    nii_fn = fullfile(mfs_folder, strcat(fig_maps{c_map}, fmt));
    mdm_nii_write(I, nii_fn, h);
end


end
