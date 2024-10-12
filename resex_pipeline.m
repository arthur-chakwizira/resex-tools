%pipeline for analysis of RESEX data
%Author: Arthur Chakwizira, Medical Radiation Physics, Lund, Sweden

addpath("functions")


%prepare
nii_folders = {'Subject_1\NII\', 'Subject_2\NII'}; %add folders containing dicom headers for each subject

%powder average and run fit on all of the data

for i = 1:numel(nii_folders)
    disp("Analysing " + num2str(i) + " of " + num2str(numel(nii_folders)) + " ...")
    
    nii_folder = nii_folders{i};
    nii_fn = 'Subject_1\NII\s_dn_merge_mc.nii.gz'; %insert path to nii volume after denoising, de-Gibbs, merging, motion and eddy correction, etc...
    
    %now powder
    s_preprocessed = mdm_s_from_nii(nii_fn);
    s_pa = resex_do_powder_average(s_preprocessed, nii_folder);
    mdm_s_mask(s_pa);
    
    %run fit
    resex_run_fit(s_pa);
end

