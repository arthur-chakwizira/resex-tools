function [gwf, fn] = resex_get_gwf_from_dcm_hdr(nii_folder)
%gwf is a structure with fields g, rf, dt
hdr_path = fullfile(nii_folder, 'dcmHeaders.mat');
disp(['Loading gwf from dicom headers at ' hdr_path])
load(hdr_path, 'h');
h_all = h;
fn = fieldnames(h_all);
gwf.g = cell(length(fn), 1);
gwf.rf = cell(length(fn), 1);
gwf.dt = cell(length(fn), 1);
gwf.Gamma = cell(length(fn), 1);
gwf.Vomega = cell(length(fn), 1);

figure('Position',  [359 523 1083 435]);
hold on
ax1 = subplot(1,2,1);
hold(ax1, 'on')
ax2 = subplot(1,2,2);
hold(ax2, 'on')

cols = linspecer(length(fn), 'sequential');

for c_fn = 1:length(fn)
    h = h_all.(fn{c_fn});
   [g, rf, dt] = fwf_gwf_from_siemens_hdr(h); %suppressed rf
   %this is where we downsample----------------
   g = g(:,1).*rf;
   dt_new = 1e-3; %want 1 ms for fitting
   [g, rf] = gwf_subsample_1d(g, dt, dt_new);
   g = g.*rf;
   gwf.g{c_fn} = g;
%    gwf.rf{c_fn} = rf;
   gwf.dt{c_fn} = dt_new;
   %we will now add fields Gamma and Vomega to xps----------------------
   %this will quicken fitting A LOT
   [gam, vom] = resex_mc_protocol_to_gamma_vomega(g', dt_new);
   gwf.Gamma{c_fn} = gam;
   gwf.Vomega{c_fn} = vom;
   
   t = 0:dt_new:((numel(g(:,1))-1)*dt_new);
   
   plot(ax1, t, g, 'Color', cols(c_fn, :), 'LineWidth', 3)
   plt = plot(ax2, gam*1e3, (vom), 'o', 'MarkerSize', 10);
   set(plt, 'MarkerFaceColor', cols(c_fn, :))
end

xlabel(ax2, '\Gamma [s]')
ylabel(ax2, 'V_{\omega} [s^{-2}]')
xlabel(ax1, 'Time [s]')
ylabel(ax1, 'g [T/m]')
set([ax1 ax2], 'fontsize', 16)

%these waveforms need to have equal numbers of entries for merging to work
%find maximum number of entries
len_max = 0;
for c_g = 1:length(gwf.g)
    len_max = max(size(gwf.g{c_g}, 1), len_max);
end

%pad all with zeros
for c_fn = 1:length(fn)
   gwf.g{c_fn}(end+1:len_max) = 0;
end


end
