function v_delta = f_delta_v(c_x,c_y,c_xnew,c_ynew)
% A function which calculates the difference between two sets of
% coordinates, returning a row vector with the differences.

v_delta = zeros(1,2);
v_delta(1,1) = c_xnew - c_x;
v_delta(1,2) = c_ynew - c_y;