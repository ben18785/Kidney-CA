function cell_measurables = f_update_epithelium_m(c_x,c_y,m_cell,m_GDNF,v_parameters,c_ret)
% A function which updates the cell matrix, by applying the rules of
% movement and proliferation for a cell located at (c_x,c_y)

% Choose whether to move or proliferate via p_move = 1 (for a move/competition for Ret) pr 0
% for a proliferation
ck_moveprob = v_parameters(3);
cp_move = f_moveprolif_c(ck_moveprob);


% Determine if there are allowed cells nearby which a cell can
% move/proliferate into. If there are, return the indices of these cells in
% a matrix. To begin with I am going to assume that the allowed movements
% and proliferation possiblities are the same. Am passing v_parameters in
% order to allow me to specify what determines an allowed move e.g. 4 vs 8
% possibilites, connected vs unconnected etc

[c_allowed,m_allowedindices] = f_epithelium_allowed_cm(c_x,c_y,m_cell,v_parameters,cp_move);


% If no positions are available, then just return the original matrix
if c_allowed == 0
    c_mesenchyme_options = 0;
    c_heterogeneity = 0;
    m_cell = m_cell; % Not sure if I need to do this. Must be redundant.
    c_move = 0;
    c_vacant_select = 0;
    c_mesenchyme_select = 0;
    
    cell_measurables = cell(4,1);
    cell_measurables{1,1} = m_cell;
    cell_measurables{2,1} = c_heterogeneity;
    cell_measurables{3,1} = c_mesenchyme_options;
    cell_measurables{4,1} = c_move;
    cell_measurables{5,1} = c_vacant_select;
    cell_measurables{6,1} = c_mesenchyme_select;
    cell_measurables{7,1} = 0;
    cell_measurables{8,1} = [];
    
    return;
end

% Move or proliferate in accordance with the rules. Again passing the
% vector of parameters to allow user to select different rules.
switch cp_move
    case 1
        cell_measurables = f_move_epithelium_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters,c_ret);
    case 0 
        cell_measurables = f_prolif_epithelium_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters,c_ret);
     
end


