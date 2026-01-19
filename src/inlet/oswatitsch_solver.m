function sol = oswatitsch_solver(M1, Mn_target, gamma, n_oblique)
% oswatitsch_solver
% This solver designs a multi-shock inlet using Oswatitsch equal-strength principle:
%   Mi sin(beta_i) = Mn*  for all oblique shocks
% with n_oblique oblique shocks followed by a terminal normal shock whose
% upstream Mach is specified as Mn_target.


    if n_oblique ~= 3
        error('This assignment specifies 3 oblique shocks. Set n_oblique = 3.');
    end

    % ---- Find Mn* by 1D root solve on residual(M4 - Mn_target) ----
    resfun = @(Mn_star) residual_M4(Mn_star, M1, Mn_target, gamma, n_oblique);

    % Bracket the root by scanning (robust, avoids bad initial guesses)
    Mn_min = 1.001;             % must be >1 for a shock
    Mn_max = min(2.5, M1-1e-3); % Mn* <= Mi; this is conservative upper
    grid = linspace(Mn_min, Mn_max, 400);

    rvals = nan(size(grid));
    for k = 1:numel(grid)
        rvals(k) = resfun(grid(k));
    end

    % Find sign change for fzero
    idx = find(isfinite(rvals(1:end-1)) & isfinite(rvals(2:end)) & (rvals(1:end-1).*rvals(2:end) < 0), 1, 'first');

    if ~isempty(idx)
        a = grid(idx);
        b = grid(idx+1);
        Mn_star = fzero(resfun, [a, b]);
    else
        % Fallback: minimize absolute residual if no sign change found
        warning('No bracketed root found. Falling back to fminsearch on |residual|. Check feasibility.');
        obj = @(Mn_star) abs(resfun(Mn_star));
        Mn_star = fminsearch(obj, 1.3);
    end

    % ---- With Mn* found, compute full stage-by-stage solution ----
    [M, beta, theta, pi_obl] = forward_chain(Mn_star, M1, gamma, n_oblique);

    % Terminal normal shock (given upstream Mach Mn_target)
    [M_after_normal, pi_normal] = normal_shock(Mn_target, gamma);

    % Total inlet pressure recovery
    pi_d = prod(pi_obl) * pi_normal;

    % Pack output
    sol = struct();
    sol.gamma = gamma;
    sol.M1 = M1;
    sol.n_oblique = n_oblique;

    sol.Mn_star = Mn_star;
    sol.Mn_target = Mn_target;

    sol.M = M;                % size n_oblique+1 : M1..M4 (before normal shock)
    sol.beta = beta;          % 1..n_oblique
    sol.theta = theta;        % 1..n_oblique
    sol.pi_obl = pi_obl;      % 1..n_oblique

    sol.M_after_normal = M_after_normal;
    sol.pi_normal = pi_normal;
    sol.pi_d = pi_d;
end

%  Helper functions 

function r = residual_M4(Mn_star, M1, Mn_target, gamma, n_oblique)
    % Returns M4 - Mn_target for a trial Mn_star.
    % If infeasible (detached shock, invalid angles), return NaN.
    [M, ~, theta, ~] = forward_chain(Mn_star, M1, gamma, n_oblique);

    if any(~isfinite(M)) || any(~isfinite(theta))
        r = NaN;
        return;
    end

    M4 = M(end);
    r = M4 - Mn_target;
end

function [M, beta, theta, pi_obl] = forward_chain(Mn_star, M1, gamma, n_oblique)
    % Computes stages given Mn_star.
    % M(1)=M1, M(2)=M2, ... M(n_oblique+1)=M4.

    M = nan(n_oblique+1, 1);
    beta = nan(n_oblique, 1);
    theta = nan(n_oblique, 1);
    pi_obl = nan(n_oblique, 1);

    M(1) = M1;

    for i = 1:n_oblique
        Mi = M(i);

        % Feasibility: Mn_star must be <= Mi and > 1
        if ~(Mn_star > 1.0 && Mn_star < Mi)
            M(:) = NaN; beta(:)=NaN; theta(:)=NaN; pi_obl(:)=NaN;
            return;
        end

        % Oswatitsch condition => beta from Mn_star = Mi*sin(beta)
        beta_i = asin(Mn_star / Mi);

        % Compute oblique shock outcome
        [theta_i, Mip1, pi_i, ok] = oblique_shock(Mi, beta_i, gamma);

        if ~ok
            M(:) = NaN; beta(:)=NaN; theta(:)=NaN; pi_obl(:)=NaN;
            return;
        end

        beta(i) = beta_i;
        theta(i) = theta_i;
        M(i+1) = Mip1;
        pi_obl(i) = pi_i;
    end
end