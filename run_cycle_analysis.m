% run_cycle_analysis.m
% Part II: parametric cycle analysis for fictional engine.

clear; clc; close all;

%  Flight condition 
fc.M0 = 3.2;
fc.h_m = 15000;              % altitude [m] (change if you want)
fc.gamma = 1.4;
fc.R = 287.05;
fc.cp = fc.gamma*fc.R/(fc.gamma-1);

% Inlet pressure recovery from Part I (Oswatitsch inlet)
fc.pi_d = 0.7925615509;

%  Baseline component assumptions (reasonable starting points) 
p = engine_params_baseline(fc);

%  Parametric ranges 
pi_c_vec  = linspace(8, 30, 40);          % compressor pressure ratio sweep
Tt4_vec   = linspace(1500, 2000, 40);     % turbine inlet temperature sweep [K]

%  Run parametric study 
res = parametric_study(fc, p, pi_c_vec, Tt4_vec);

%  Plots 
figure('Name','Specific Thrust');
imagesc(pi_c_vec, Tt4_vec, res.Fspec); axis xy; colorbar;
xlabel('\pi_c'); ylabel('T_{t4} (K)');
title('Specific Thrust (N per (kg/s) air)');

figure('Name','TSFC');
imagesc(pi_c_vec, Tt4_vec, res.TSFC); axis xy; colorbar;
xlabel('\pi_c'); ylabel('T_{t4} (K)');
title('TSFC (kg/(N*s))');

%  Save results 
if ~exist('results','dir'); mkdir('results'); end
save('results/cycle_parametric_results.mat','fc','p','pi_c_vec','Tt4_vec','res');

% Print a “best” point by a simple objective (min TSFC with Fspec constraint) 
Fmin = 250; % N/(kg/s) constraint
mask = res.Fspec >= Fmin;
TS = res.TSFC; TS(~mask) = NaN;

[minTS, idx] = min(TS(:));
[iT, iP] = ind2sub(size(TS), idx);

fprintf('\n=== Part II Parametric Study Summary ===\n');
fprintf('Constraint: Fspec >= %.1f\n', Fmin);
fprintf('Best (min TSFC) found at:\n');
fprintf('  pi_c = %.2f, Tt4 = %.1f K\n', pi_c_vec(iP), Tt4_vec(iT));
fprintf('  Fspec = %.2f N/(kg/s)\n', res.Fspec(iT,iP));
fprintf('  TSFC  = %.6e kg/(N*s)\n', res.TSFC(iT,iP));