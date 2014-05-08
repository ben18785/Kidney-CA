function m_cell = f_pmoveselector_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which selects probabilistically from a list of available moves
% and (dependent on the exact rule being implemented), moves the cell at
% (c_x,c_y) to that cell, and updates the cell matrix m_cell

% Get the particular rule being used
ck_moving_rule = v_parameters(12);

% Also need to get the value of the parameter which specifies the parameter
% ck_movement_rule. This is necessary if we are to use cases 4-6 here,
% since we must be able to move the mesenchymal cell into a vacant spot.
ck_movement_rule = v_parameters(5);


% Based on the particular rule being chosen, implement the appropriate one
switch ck_moving_rule
    case 1 % All moves are given equal probability
        m_cell = f_pmoving_rule1_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
    case 2 % Move probability is weighted by the magnitude of the gradient of GDNF
        m_cell = f_pmoving_rule2_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
    case 3 % Move probability is weighted by the percentage increase in GDNF available
        m_cell = f_pmoving_rule3_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
    case 4 % Same as case 3 but now the mesenchyme are moved if the epithelium wants to move into their spot
        if ck_movement_rule == 6
            m_cell = f_pmoving_rule4_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
        else
           'Error: cannot use these specifications for the movement rules. If mesenchymal cells are to be moved, then we need to be sure that there are spaces available for them. Specify ck_movement_rule == 6' 
        end
    case 5 % Move probability here is given by a multinomial logit distribution
        m_cell = f_pmoving_rule5_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
        
    case 6 % Same as case 5, but now the mesenchyme are moved if the epithelium wants to move into their spot
        if ck_movement_rule == 6
            m_cell = f_pmoving_rule6_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters);
        else
           'Error: cannot use these specifications for the movement rules. If mesenchymal cells are to be moved, then we need to be sure that there are spaces available for them. Specify ck_movement_rule == 6' 
        end
    otherwise
        'Something has gone wrong with the parameter for specifying how to probabilistically choose between cells in f_pmoveselector_m...'
        return;
end

