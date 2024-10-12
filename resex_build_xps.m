%build xps files for all resex nifti volumes using the gwf txt files


nii_fn_list = {'resex_1\sub-phy001_ses-001_acq-difffwf2mmresex1b4000_dir-AP_run-1_part-mag_dwi.nii.gz',...
     'resex_2\sub-phy001_ses-001_acq-difffwf2mmresex2b4000_dir-AP_run-1_part-mag_dwi.nii.gz',...
     'resex_3\sub-phy001_ses-001_acq-difffwf2mmresex3b4000_dir-AP_run-1_part-mag_dwi.nii.gz'}; %paths to ResEx nifti volumes

gwf_txt_A_fn_list = {'resex_1\FWF_CUSTOM001_A.txt', 'resex_2\FWF_CUSTOM002_A.txt', 'resex_3\FWF_CUSTOM003_A.txt'}; %paths to gwf text files corresponding to the niftis above
gwf_txt_B_fn_list = {'resex_1\FWF_CUSTOM001_B.txt', 'resex_2\FWF_CUSTOM002_B.txt', 'resex_3\FWF_CUSTOM003_B.txt'};

pause_dur_fn_list = {'resex_1\PauseDur.txt', 'resex_2\PauseDur.txt', 'resex_3\PauseDur.txt'}; %paths to text files containing pause durations

 
%loop through the above and generate xps files
for i = 1:numel(nii_fn_list)
    
    nii_fn = nii_fn_list{i};
    gwf_txt_A_fn = gwf_txt_A_fn_list{i};
    gwf_txt_B_fn = gwf_txt_B_fn_list{i};
    pause_dur_fn = pause_dur_fn_list{i};

    xps = resex_build_xps_from_gwf_txt(gwf_txt_A_fn, gwf_txt_B_fn, pause_dur_fn, nii_fn);

end

