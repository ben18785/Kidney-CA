function v_delta_move = f_delta_move_v(c_xold,c_yold,c_xnew,c_ynew,v_parameters)
% A function which finds the move vector between the old and new positions
% taking into account the periodicity in the y coordinates
c_width_full = v_parameters(7);
v_delta_move(1) = c_xnew - c_xold;

if and(and(c_ynew ~= 1, c_ynew ~= c_width_full),and(c_yold ~= 1, c_yold ~= c_width_full)) % Normal
    v_delta_move(2) = c_ynew - c_yold; 
elseif and(c_yold == 1,c_ynew == c_width_full) % Going from start back to end
    v_delta_move(2) = -1;
elseif and(c_yold == c_width_full,c_ynew == 1) % Going from end to start
    v_delta_move(2) = 1;
else
    v_delta_move(2) = c_ynew - c_yold;  % Situations when c_yold and c_ynew are 1
end
    
    