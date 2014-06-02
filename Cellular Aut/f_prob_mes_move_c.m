function [c_move,m_allowedindices] = f_prob_mes_move_c(c_x,c_y,m_GDNF,m_cell,m_distance,v_parameters,cp_move_or_prolif)
% A function which determines whether or not a move of a mesenchyme cell at
% (c_x,c_y) takes place, returning 1 if it does; 0 otherwise. It also
% yields the indices of spaces available for the mesenchyme to move into.

% First determine if there are any neighbouring cells into which to move,
% and returns the indices of the available move locations
[c_allowed,m_allowedindices] = f_mes_move_allowed_c(c_x,c_y,m_GDNF,m_cell,v_parameters);

% If there are no available cells then just return c_move = 0.
if c_allowed == 0
    c_move = 0;
    m_allowedindices = [];
    return;
end

% If there are allowed moves, determine whether one takes place
% probabilistically
c_move = f_mes_move_prob_c(c_x,c_y,m_allowedindices,m_GDNF,m_cell,m_distance,v_parameters,cp_move_or_prolif);