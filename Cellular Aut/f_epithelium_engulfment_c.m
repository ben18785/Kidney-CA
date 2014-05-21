function c_allowed = f_epithelium_engulfment_c(c_x,c_y,m_cell,v_parameters)
% A function which checks to see whether an epithelium move will result in
% the engulfment of a mesenchyme cell. (c_x,c_y) is the position of the
% proposed move of epithelium. The function goes through and first finds
% all the neighbouring mesenchyme to the spot, then checks whether each
% mesenchyme will become trapped on movement of the epithelium there.

% First of all make a copy of the cell array
m_cell_copy = m_cell;
m_cell_copy(c_x,c_y) = 1;

% Now find all its nearest neighbours
m_nearest = f_allindices_8neigh_m(c_x,c_y,v_parameters);

% Now find the indices of all the neighbours which are mesenchyme
m_mesenchyme = f_find_mesenchyme_m(m_nearest,m_cell_copy);

% Now go through and determie whether any of the mesenchyme will become
% trapped by the movement
c_allowed = f_mesenchyme_engulfment_c(m_mesenchyme,m_cell_copy,v_parameters);