%pipeline for analysis of RESEX data
%Author: Arthur Chakwizira, Medical Radiation Physics, Lund, Sweden

addpath("functions")


%prepare
nii_folders = {'Subject_1\NII\', 'Subject_2\NII'}; %add folders containing dicom headers for each subject


%build xps, powder average and run fit on all of the data

for i = 1:numel(nii_folders)
    disp("Analysing " + num2str(i) + " of " + num2str(numel(nii_folders)) + " ...")
    
    nii_folder = nii_folders{i};
    nii_fn = 'Subject_1\NII\s_dn_merge_mc.nii.gz'; %insert path to nii volume after denoising, de-Gibbs, merging, motion and eddy correction, etc...
    
    clear('s')
    %get gradient waveforms from dicom header and build xps using these
    [gwf, gwf_fn] = resex_get_gwf_from_dcm_hdr(nii_folder);
    s = resex_build_s_from_nii(nii_folder, gwf_fn);
    s = resex_add_gwf_to_s(s, gwf);
    %merge xps here
    s = resex_merge_xps(s);
    
    %save the generated xps
    xps_fn = mdm_xps_fn_from_nii_fn(nii_fn);
    mdm_xps_save(s.xps, xps_fn);
    s_preprocessed = mdm_s_from_nii(nii_fn);
    
    %now powder
    s_pa = do_powder_average(s_preprocessed, nii_folder);
    mdm_s_mask(s_pa);
    
    %run fit
    resex_run_fit(s_pa);
end

