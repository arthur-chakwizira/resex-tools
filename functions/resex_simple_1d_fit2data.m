function s = resex_simple_1d_fit2data(m, xps)
% function s = resex_simple_1d_fit2data(m, xps)
%

s0     = m(1);
E_D  = m(2);
E_R  = m(3);
V = m(4);
k = m(5);

E = E_D + xps.Vomega*E_R;
% h = 2*sum(xps.q4.*exp(-k*xps.t), 2)*xps.dt(1);
h = 1-k*xps.Gamma;
s = s0*exp(-xps.b.*E + (1/2)*V*h.*xps.b.^2);
