function cell_measurables = f_implement_move_cell(c_move_index,m_cell,m_allowedindices,c_x,c_y,cellm_mesenchyme_available,v_parameters,c_heterogeneity,c_move)
% A function which implements the movement/proliferation of the epithelium chosen, and returns a cell array
% with the measurable components in it. (c_x,c_y) is the location of the
% epithelium before the move

% Start with an empty array which will only be filled in if mesenchyme are
% moved
cell_temp = [];

% Either do the required movement or proliferation
switch c_move
    case 1 % Move
        % Get the particular rule being used
        ck_moving_rule = v_parameters(12);

        if ck_moving_rule == 4 | ck_moving_rule == 6 | ck_moving_rule == 7 % Moving mesenchyme therefore have a cell array with their positions
            if m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) ~= -1 % If not mesenchyme
                    
                    m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = m_cell(c_x,c_y); % Now allow for either a Ret low or Ret high cell to move
                    m_cell(c_x,c_y) = 0;
                    c_mesenchyme_options = 0;
                    c_vacant_select = 1;
                    c_mesenchyme_select = 0;
            else % If mesenchyme
                    cell_temp = f_mesenchyme_target_choice_m(m_cell,c_x,c_y,m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2),m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2),cellm_mesenchyme_available{c_move_index},v_parameters);
                    m_cell = cell_temp{1,1};
                    m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = m_cell(c_x,c_y);
                    m_cell(c_x,c_y) = 0;
                    c_mesenchyme_options = length_new(cellm_mesenchyme_available{c_move_index});
                    c_vacant_select = 0;
                    c_mesenchyme_select = 1;
            end
        else 
            
            m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = m_cell(c_x,c_y);
            m_cell(c_x,c_y) = 0;
            c_mesenchyme_options = 0;
            c_vacant_select = 1;
            c_mesenchyme_select = 0;
        end
    case 0 % Proliferation
        % Get the particular rule being used
        ck_prolif_choosecell_rule = v_parameters(15);
        if ck_prolif_choosecell_rule == 4 | ck_prolif_choosecell_rule == 6 | ck_prolif_choosecell_rule == 7 % Moving mesenchyme therefore have a cell array with their positions
            if m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) ~= -1 % If not mesenchyme
                    m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = m_cell(c_x,c_y);
                    c_mesenchyme_options = 0;
                    c_vacant_select = 1;
                    c_mesenchyme_select = 0;
            else % If mesenchyme
                    cell_temp = f_mesenchyme_target_choice_m(m_cell,c_x,c_y,m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2),m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2),cellm_mesenchyme_available{c_move_index},v_parameters);
                    m_cell = cell_temp{1,1};
                    m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = m_cell(c_x,c_y);
                    c_mesenchyme_options = length_new(cellm_mesenchyme_available{c_move_index});
                    c_vacant_select = 0;
                    c_mesenchyme_select = 1;
            end
        else
            m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = m_cell(c_x,c_y);
            c_mesenchyme_options = 0;
            c_vacant_select = 1;
            c_mesenchyme_select = 0;
        end
        
        
end

c_multiple_options = length_new(m_allowedindices);
c_cell_options = 0;
if c_multiple_options > 1
    c_cell_options = 1;
end

cell_measurables = cell(5,1);
cell_measurables{1,1} = m_cell;
cell_measurables{2,1} = c_heterogeneity;
cell_measurables{3,1} = c_mesenchyme_options;
cell_measurables{5,1} = c_vacant_select;
cell_measurables{6,1} = c_mesenchyme_select;
cell_measurables{7,1} = c_cell_options;

% Store the positions of the old mesenchyme (hence why not c_x,c_y) and new cells along with their type
if isempty(cell_temp) == false
    m_temp = cell_temp{2,1};
    v_temp = m_temp(2,:);
    cell_measurables{8,1} = [m_allowedindices(c_move_index,1) m_allowedindices(c_move_index,2) m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)); v_temp];
end