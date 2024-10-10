function s = resex_do_powder_average(s, o_path)
    disp(['Powder averaging volumes at ' s.nii_fn])
    s = mdm_s_powder_average(s, o_path);
    disp(['Saving powder to ' s.nii_fn])
end