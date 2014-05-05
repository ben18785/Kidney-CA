function m_cell = f_pmoveselector_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which selects probabilistically from a list of available moves
% and (dependent on the exact rule being implemented), moves the cell at
% (c_x,c_y) to that cell, and updates the cell matrix m_cell

% Get the particular rule being used
ck_moving_rule = v_parameters(12);

% Based on the particular rule being chosen, implement the appropriate one
switch ck_moving_rule
    case 1 % All moves are given equal probability
        m_cell = f_pmoving_rule1_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
    case 2
        m_cell = f_pmoving_rule2_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
    case 3
        m_cell = f_pmoving_rule3_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
    otherwise
        'Something has gone wrong with the parameter for specifying how to probabilistically choose between cells in f_pmoveselector_m...'
        return;
end

