function res = parametric_study(fc, p, pi_c_vec, Tt4_vec)
% Returns matrices over (Tt4, pi_c)

nP = numel(pi_c_vec);
nT = numel(Tt4_vec);

Fspec = nan(nT, nP);
TSFC  = nan(nT, nP);

for iT = 1:nT
    for iP = 1:nP
        out = cycle_analysis(fc, p, pi_c_vec(iP), Tt4_vec(iT));
        Fspec(iT,iP) = out.Fspec;
        TSFC(iT,iP)  = out.TSFC;
    end
end

res = struct();
res.Fspec = Fspec;
res.TSFC = TSFC;
end