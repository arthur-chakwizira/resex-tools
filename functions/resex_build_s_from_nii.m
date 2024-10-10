function s = resex_build_s_from_nii(nii_folder, fn_list)
s = cell(max(size(fn_list)), 1);
for c_s = 1:numel(s)
    nii_fn = fullfile(nii_folder, strcat(fn_list{c_s}, '.nii.gz'));
    tmp_s = mdm_s_from_nii(nii_fn);
        %replace b-values with correct ones
    b_correct = resex_read_dvs_local(max(tmp_s.xps.b));
    first_b = find(tmp_s.xps.b ~= 0, 1, 'first');
    if first_b ~= 2 %this means there are added bzeros in the data
        tmp_s.xps.b((first_b-1):(first_b-2 + numel(b_correct))) = b_correct;
    else
     tmp_s.xps.b = b_correct;
    end
    s{c_s} = tmp_s;
end
end