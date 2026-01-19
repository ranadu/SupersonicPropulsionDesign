function [T, P, a] = atmosphere_simple(h, gamma, R)
% atmosphere_simple: ISA troposphere/stratosphere approximation.

g0 = 9.80665;
T0 = 288.15;
P0 = 101325;

if h < 11000
    L = -0.0065;
    T = T0 + L*h;
    P = P0 * (T/T0)^(-g0/(L*R));
else
    T11 = T0 - 0.0065*11000;
    P11 = P0 * (T11/T0)^(-g0/(-0.0065*R));
    T = T11;
    P = P11 * exp(-g0*(h-11000)/(R*T));
end

a = sqrt(gamma*R*T);
end