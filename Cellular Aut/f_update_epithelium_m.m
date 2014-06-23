function cell_measurables = f_update_epithelium_m(c_x,c_y,m_cell,m_GDNF,v_parameters,c_ret)
% A function which updates the cell matrix, by applying either the rules of
% competition or movement/proliferation for a cell located at (c_x,c_y)

% If Ret activity is not on, just proceed as usual
if v_parameters(40) > 0
    % Check whether Ret competition is on, if the cell is Ret high, and if
    % there are any cells neighbouring which are Ret-L and have a higher
    % concentration of GDNF
    if v_parameters(53) > 0 && c_ret == 2

        [c_allowed,m_index_GDNF_high] = f_ret_competition_allowed_c(c_x,c_y,m_cell,m_GDNF,v_parameters);

        if c_allowed > 0 % If there are allowed cells to swap with

            % Calculate the probability that competition occurs with the
            % neighbouring cells
            c_prob_comp = v_parameters(55);
            c_swap = f_prob_arbiter_c(c_prob_comp);

            if c_swap == 1 % If swap is to go ahead
                cell_measurables = f_ret_comp_swap(c_x,c_y,m_index_GDNF_high,m_cell,m_GDNF,v_parameters);
                return;
            else % If not, just implement the normal move/proliferation
                cell_measurables = f_update_moveprolif_m(c_x,c_y,m_cell,m_GDNF,v_parameters,c_ret);
            end

        else % If there are no allowed cells to swap with
            cell_measurables = f_update_moveprolif_m(c_x,c_y,m_cell,m_GDNF,v_parameters,c_ret);
        end

    else % If not, just continue with proliferation

        cell_measurables = f_update_moveprolif_m(c_x,c_y,m_cell,m_GDNF,v_parameters,c_ret);

    end
else % Proceed as usual if not on
    cell_measurables = f_update_moveprolif_m(c_x,c_y,m_cell,m_GDNF,v_parameters,c_ret);
end

