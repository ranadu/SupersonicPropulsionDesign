function out = cycle_analysis(fc, p, pi_c, Tt4)
% cycle_analysis
% Simple 1-D turbojet cycle at given flight condition and design inputs.
% Returns specific thrust, TSFC, and key station totals.


gamma = fc.gamma; R = fc.R; cp = fc.cp;

% Atmosphere (ISA-ish simple model)
[Ta, Pa, a0] = atmosphere_simple(fc.h_m, gamma, R);

M0 = fc.M0;
V0 = M0 * a0;

% Freestream stagnation (diffuser inlet, ideal)
Tt0 = Ta * (1 + (gamma-1)/2 * M0^2);
Pt0 = Pa * (1 + (gamma-1)/2 * M0^2)^(gamma/(gamma-1));

% Inlet total pressure recovery (from Part I)
Tt2 = Tt0;
Pt2 = fc.pi_d * Pt0;

% Compressor
Pt3 = Pt2 * pi_c;
tau_c_ideal = pi_c^((gamma-1)/gamma);
Tt3 = Tt2 * (1 + (tau_c_ideal - 1)/p.eta_c);

% Combustor (set Tt4)
Tt4 = min(Tt4, p.Tt4_max);
Pt4 = Pt3 * p.pi_b;

% Fuel-air ratio from energy balance
f = (cp*(Tt4 - Tt3)) / (p.eta_b * p.h_PR - cp*Tt4);
if f <= 0
    out = bad_out(); return;
end

% Turbine: drives compressor
% Power balance: (1+f)*cp*(Tt4 - Tt5)*eta_m = cp*(Tt3 - Tt2)
Tt5 = Tt4 - (Tt3 - Tt2)/(p.eta_m*(1+f));
if Tt5 <= Ta
    out = bad_out(); return;
end

% Turbine pressure ratio from efficiency (simplified)
tau_t = Tt5 / Tt4; % < 1
% Ideal temperature ratio would be lower drop for same PR; use eta_t:
% eta_t = (1 - tau_t)/(1 - tau_t_ideal) => tau_t_ideal = 1 - (1 - tau_t)/eta_t
tau_t_ideal = 1 - (1 - tau_t)/p.eta_t;

if tau_t_ideal <= 0
    out = bad_out(); return;
end

pi_t = tau_t_ideal^(gamma/(gamma-1)); % Pt5/Pt4
Pt5 = Pt4 * pi_t;

% Nozzle entry (duct loss)
Pt9 = Pt5 * p.pi_n;
Tt9 = Tt5;

% Nozzle expansion to ambient (assume perfectly expanded if possible)
% Compute ideally expanded exit Mach from Pt9/Pa:
pr = Pt9 / Pa;
if pr <= 1
    out = bad_out(); return;
end

Me = sqrt( (2/(gamma-1)) * (pr^((gamma-1)/gamma) - 1) );
Te = Tt9 / (1 + (gamma-1)/2 * Me^2);

ae = sqrt(gamma*R*Te);
Ve_ideal = Me * ae;
Ve = sqrt(p.eta_n) * Ve_ideal; % apply nozzle efficiency

% Specific thrust (pressure thrust neglected under perfect expansion)
Fspec = (1+f)*Ve - V0;

% TSFC
TSFC = f / Fspec; % kg fuel per N*s

% Efficiencies (optional but nice for report)
KE_jet = 0.5*(1+f)*Ve^2 - 0.5*V0^2;
eta_th = KE_jet / (f*p.h_PR);
eta_p  = Fspec*V0 / (KE_jet);
eta_o  = eta_th * eta_p;

% Output struct
out = struct();
out.Fspec = Fspec;
out.TSFC = TSFC;
out.f = f;

out.Ta = Ta; out.Pa = Pa; out.V0 = V0;
out.Tt0 = Tt0; out.Pt0 = Pt0;
out.Tt2 = Tt2; out.Pt2 = Pt2;
out.Tt3 = Tt3; out.Pt3 = Pt3;
out.Tt4 = Tt4; out.Pt4 = Pt4;
out.Tt5 = Tt5; out.Pt5 = Pt5;
out.Tt9 = Tt9; out.Pt9 = Pt9;

out.Ve = Ve;
out.eta_th = eta_th;
out.eta_p  = eta_p;
out.eta_o  = eta_o;
end

function out = bad_out()
out = struct('Fspec', NaN, 'TSFC', NaN, 'f', NaN);
end