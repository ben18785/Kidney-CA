function [v_xposs_princ,v_yposs_princ] = f_spacecomponents_princ_vv(v_delta_move,c_xnew,c_ynew,v_parameters,c_prin_or_sec)
% A function which returns the x and y components (some of which may not be
% feasible (as they may be out of the domain).

% Get the dimensions of the matrix being used
c_depth_full = v_parameters(6);
c_width_full = v_parameters(7);

% Create empty vectors to store results
v_xposs_princ = zeros(c_prin_or_sec,1);
v_yposs_princ = zeros(c_prin_or_sec,1);

% Get x components
if abs(v_delta_move(1)) > 0 % Only if there is some x movement in the principal direction
    for i = 1:(c_prin_or_sec + 1)
     v_xposs_princ(i) = c_xnew - v_delta_move(1) + (i-1)*v_delta_move(1);
    end
end

% Transform the y so that we can do modulo arithmetic, and get principal
% axis components of y
if abs(v_delta_move(2)) > 0 % Only if there is some y movement in the principal direction
    for i = 1:(c_prin_or_sec + 1)
     v_yposs_princ(i) = 1 + mod(c_xnew - v_delta_move(1) + (i-1)*v_delta_move(1) - 1,c_width_full); % -1 is taking into account modulo
    end
end