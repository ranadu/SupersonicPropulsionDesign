% run_inlet_design.m

clear; clc; close all;

%  Inputs 
gamma = 1.4;
M1 = 3.2;          % freestream Mach
Mn_target = 1.3;   % upstream Mach of the terminal normal shock
n_oblique = 3;     % 3 oblique shocks + 1 normal shock

%  Solve Oswatitsch inlet 
sol = oswatitsch_solver(M1, Mn_target, gamma, n_oblique);

%  Print summary 
fprintf('\n=== Oswatitsch Supersonic Inlet Design ===\n');
fprintf('Inputs: M1 = %.4f, gamma = %.4f, # oblique shocks = %d, Mn(target) = %.4f\n', ...
    M1, gamma, n_oblique, Mn_target);

fprintf('\nEqual-strength normal Mach across oblique shocks:\n');
fprintf('  Mn* = %.6f\n', sol.Mn_star);

fprintf('\nStage results (Oblique shocks):\n');
fprintf('  i     Mi        beta_i(deg)    theta_i(deg)    Mi+1       pi_i=P0_out/P0_in\n');
for i = 1:n_oblique
    fprintf('  %d   %8.5f   %12.6f   %12.6f   %8.5f     %12.8f\n', ...
        i, sol.M(i), rad2deg(sol.beta(i)), rad2deg(sol.theta(i)), sol.M(i+1), sol.pi_obl(i));
end

fprintf('\nTerminal normal shock:\n');
fprintf('  Mn (upstream) = %.6f\n', sol.Mn_target);
fprintf('  M_after_normal = %.6f\n', sol.M_after_normal);
fprintf('  pi_normal = %.8f\n', sol.pi_normal);

fprintf('\nTotal inlet pressure recovery:\n');
fprintf('  pi_d = %.10f\n', sol.pi_d);

%  Plot inlet geometry (simple rendered ramp) 
figure('Name','Inlet Ramp Geometry');
inlet_geometry(sol.theta);
title('3-Ramp Inlet Geometry (Angles from Oswatitsch design)');
axis equal; grid on;

%  Plot shock angles for visualization 
figure('Name','Shock / Deflection Angles');
bar([rad2deg(sol.beta(:)), rad2deg(sol.theta(:))]);
xlabel('Oblique Shock Index');
ylabel('Angle (deg)');
legend('\beta (shock angle)','\theta (deflection)','Location','northwest');
grid on;

%  Save a quick results struct 
if ~exist('results','dir'); mkdir('results'); end
save('results/inlet_design_results.mat', 'sol');

fprintf('\nSaved: results/inlet_design_results.mat\n');