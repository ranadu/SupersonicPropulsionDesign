function p = engine_params_olympus593()
% Off-the-shelf baseline: Rolls-Royce/Snecma Olympus 593 (Concorde).
% Reference data (historical): compressor PR ~15.5, TET ~1980 F (~1355 K).

p = struct();

% Efficiencies (kept comparable to baseline; you can refine later)
p.eta_c = 0.86;
p.eta_t = 0.90;
p.eta_b = 0.98;
p.eta_n = 0.95;
p.eta_m = 0.99;

% Pressure losses
p.pi_b = 0.95;
p.pi_n = 0.99;

% Fuel
p.h_PR = 43e6;

% Olympus reference TIT/TET (approx): 1980 F ~ 1355 K
p.Tt4_max = 1355;

p.name = "Olympus 593 (baseline data point)";
end