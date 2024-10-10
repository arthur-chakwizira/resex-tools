function s_new = resex_merge_xps(s)
%merge xps files in s struct
xps = cell(1, numel(s));
for c = 1:numel(s)
    xps{c} = s{c}.xps;
end

s_new.xps = mdm_xps_merge(xps);
end