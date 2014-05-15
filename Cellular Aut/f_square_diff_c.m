function c_square_diff = f_square_diff_c(v_delta_1,v_delta_2)
% A function which returns the square difference between two sets of
% coordinates; returning the result as a constant

c_square_diff = (v_delta_1(1,1) - v_delta_2(1,1))^2 + (v_delta_1(1,2) - v_delta_2(1,2))^2;