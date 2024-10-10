function s = resex_add_gwf_to_s(s, gwf)
ns = max(size(s));
for c_ns = 1:ns
    tmp_gwf = zeros(s{c_ns}.xps.n, numel(gwf.g{c_ns}));
    tmp_q4 = zeros(s{c_ns}.xps.n, numel(gwf.g{c_ns}));
    tmp_dt = zeros(s{c_ns}.xps.n, 1);
    tmp_Gamma = zeros(s{c_ns}.xps.n, 1);
    tmp_Vomega = zeros(s{c_ns}.xps.n, 1);
    
    for c_n = 1:s{c_ns}.xps.n
%         tmp_g = fwf_gwf_to_scaled_gwf(gwf.g{c_ns}, gwf.rf{c_ns}, gwf.dt{c_ns}, s{c_ns}.xps.b(c_n));
        tmp_g = gwf.g{c_ns};
        tmp_q = msf_const_gamma*cumsum(tmp_g)*gwf.dt{c_ns};
        tmp_b = sum(tmp_q.^2)*gwf.dt{c_ns};
        tmp_g = tmp_g*sqrt(s{c_ns}.xps.b(c_n)/tmp_b);
        tmp_q = tmp_q*sqrt(s{c_ns}.xps.b(c_n)/tmp_b);
        q4 = (1/s{c_ns}.xps.b(c_n)^2)*resex_mc_correlate(tmp_q'.^2, tmp_q'.^2, gwf.dt{c_ns});
        if any(isnan(q4)); q4 = zeros(size(q4)); end

        tmp_gwf(c_n, :) = tmp_g;
        tmp_dt(c_n) = gwf.dt{c_ns};
        tmp_Gamma(c_n) = gwf.Gamma{c_ns};
        tmp_Vomega(c_n) = gwf.Vomega{c_ns};
        tmp_q4(c_n, :) = q4;
    end
    s{c_ns}.xps.gwf = tmp_gwf;
    s{c_ns}.xps.dt = tmp_dt;
    s{c_ns}.xps.Gamma = tmp_Gamma;
    s{c_ns}.xps.Vomega = tmp_Vomega;
    s{c_ns}.xps.q4 = tmp_q4;
end

end
