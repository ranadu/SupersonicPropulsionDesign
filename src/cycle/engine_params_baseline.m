function p = engine_params_baseline(fc)
% Baseline engine parameters for fictional turbojet.
% These are "starting points" for the parametric study.

p = struct();

% Efficiencies
p.eta_c = 0.88;      % compressor polytropic/overall efficiency (simplified)
p.eta_t = 0.90;      % turbine efficiency
p.eta_b = 0.98;      % burner efficiency
p.eta_n = 0.95;      % nozzle efficiency (total->kinetic)

% Pressure losses
p.pi_b = 0.95;       % combustor total pressure ratio (loss)
p.pi_n = 0.99;       % nozzle total pressure ratio (duct losses)

% Mechanical
p.eta_m = 0.99;      % shaft mechanical efficiency

% Fuel
p.h_PR = 43e6;       % fuel lower heating value [J/kg] (Jet-A approx)

% Limits / design
p.Tt4_max = 2000;    % max turbine inlet temp for sweep guardrail

% For reporting convenience
p.name = "Fictional Turbojet Baseline";
end