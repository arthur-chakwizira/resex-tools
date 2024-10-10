function m = resex_gamma_simple_1d_data2fit(signal, xps)
%fits ReseX with time-independent variance
%only have 2 Gamma-varying waveforms

%s0,      E_D,        V            k

t_ub      =   [2   3       10      500  ];
t_lb      = 0*t_ub;
%           []     [um^2*ms] [um^4/ms^2]

fun = @(t)objective(t, signal, xps); %objective

options = optimoptions(@lsqnonlin, 'MaxFunctionEvaluations', 1e6, 'Diagnostics', 'off', ...
    'FunctionTolerance', 1e-12, 'MaxIterations', 1e6, 'OptimalityTolerance', 1e-12,...
    'StepTolerance', 1e-12, 'Display', 'off');

Ntrials = 10;
RSS = inf;
for trial = 1:Ntrials
    t_0 = t_lb + rand*(t_ub-t_lb);
    %     t = lsqnonlin(fun,t_0,t_lb, t_ub, options);
    m = t2m(t_0, signal);
    tmp_signal = resex_gamma_simple_1d_fit2data(m, xps);
    tmp_RSS = sum((tmp_signal - signal).^2);
    if tmp_RSS < RSS; best_t0 = t_0; RSS = tmp_RSS; end
end
% t = best_t;
t = lsqnonlin(fun,best_t0,t_lb, t_ub, options);

% t0 = [1 1 0.5 5];
% t = lsqnonlin(fun,t0,t_lb, t_ub, options);



    function cost = objective(t_guess, signal, xps)
        m_out = t2m(t_guess, signal);
        s = resex_gamma_simple_1d_fit2data(m_out, xps);
        cost = (signal - s);
    end

    function m = t2m(t, signal) % convert local params to outside format
        
        unit_to_SI = [max(signal) 1e-9 1e-18 1];  %s0, E_D, V, k
        
        % define model parameters
        s0     = t(1);
        E_D  = t(2);
        V = t(3);
        k = t(4);
        
        m = [s0  E_D  V k] .* unit_to_SI;
    end

m = t2m(t, signal);


end