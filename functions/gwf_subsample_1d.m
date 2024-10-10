function [gwf_new, rf_new] = gwf_subsample_1d(gwf, dt_old, dt_new)
%subsample gradient waveform
wasrows = false;
if size(gwf, 1) < size(gwf, 2); wasrows = true; gwf = gwf'; end
%gwf is Nx1, rf is Nx1, dt

[N_old, gwf] = N_from_gwf(gwf); %%adding this. Ac. 2021-aug-17 because the old method (line 9) does not work for waveforms with many appended zeros

% N_old = size(gwf, 1);
% N_old = round(N_old/2); %we will downsample first half of waveform, then copy this to next half
%Changing things here because the old method (line 10), does not work when
%N_old is not a multiple of 2. AC 2022-jan-24

N_old_A = floor(N_old/2);
N_old_B = N_old - N_old_A;

%to maintain balance
% t_old = 0:dt_old:(N_old-1)*dt_old;%old time-grid for half of waveform
t_old_A = 0:dt_old:(N_old_A-1)*dt_old;%old time-grid for half of waveform
t_old_B = 0:dt_old:(N_old_B-1)*dt_old;%old time-grid for half of waveform


t_new_A = 0:dt_new:max(t_old_A); %new time-grid
N_new_A = numel(t_new_A);

t_new_B = 0:dt_new:max(t_old_B); %new time-grid
N_new_B = numel(t_new_B);


gwf_new = zeros(N_new_A + N_new_B, 1);
rf_new = zeros(N_new_A + N_new_B, 1);

tmp_gwf = gwf(1:N_old_A);
if any(isnan(tmp_gwf))
    tmp_gwf = t_new_A*0;
else
    tmp_gwf = interp1(t_old_A, tmp_gwf, t_new_A, 'pchip');
end

gwf_new(1:N_new_A) = tmp_gwf;
rf_new(1:N_new_A) = 1;

gwf_new(end-N_new_A+1:end) = flip(tmp_gwf);
rf_new(end-N_new_A+1:end) = -1;

if wasrows; gwf_new = gwf_new'; rf_new = rf_new'; end


end