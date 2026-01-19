function inlet_geometry(theta_vec)
% inlet_geometry
% Simple 2D ramp sketch using the deflection angles.
% This is a "rendition" suitable for the report.
%
% theta_vec: [theta1 theta2 theta3] (rad)

    if numel(theta_vec) ~= 3
        error('Expected 3 deflection angles.');
    end

    % Arbitrary segment lengths (for visualization)
    L = [1.0, 1.0, 1.0];

    % Ramp angles relative to freestream
    a1 = -theta_vec(1);
    a2 = -(theta_vec(1) + theta_vec(2));
    a3 = -(theta_vec(1) + theta_vec(2) + theta_vec(3));

    % Starting point
    x = 0; y = 0;
    pts = [x, y];

    % Segment 1
    x = x + L(1)*cos(a1); y = y + L(1)*sin(a1);
    pts = [pts; x, y];

    % Segment 2
    x = x + L(2)*cos(a2); y = y + L(2)*sin(a2);
    pts = [pts; x, y];

    % Segment 3
    x = x + L(3)*cos(a3); y = y + L(3)*sin(a3);
    pts = [pts; x, y];

    % Plot ramp
    plot(pts(:,1), pts(:,2), '-o', 'LineWidth', 2);
    hold on;

    % Freestream reference line
    plot([pts(1,1), pts(end,1)+0.5], [0, 0], '--', 'LineWidth', 1.5);

    xlabel('x (arb. units)');
    ylabel('y (arb. units)');

    % Annotate angles
    txt = sprintf('\\theta_1=%.2f^\\circ, \\theta_2=%.2f^\\circ, \\theta_3=%.2f^\\circ', ...
        rad2deg(theta_vec(1)), rad2deg(theta_vec(2)), rad2deg(theta_vec(3)));
    text(0.02, 0.95, txt, 'Units','normalized');

    hold off;
end