function m_cell = f_mesenchyme_target_choice_m(m_cell,c_x,c_y,c_xnew,c_ynew,c_xmes,c_ymes,m_allowed_mesenchyme_targets,v_parameters)
% A function which chooses between random mesenchyme movement selection and
% movement orientated towards the direction in which they were pushed.

c_mes_movement = v_parameters(17);

switch c_mes_movement
    case 1 % Randomly select a target cell
        m_cell = f_move_mesenchyme_outofway_m(c_xnew,c_ynew,m_allowed_mesenchyme_targets,m_cell,v_parameters);
       
    case 2 % Select a target cell probabilistically based on the direction it was pushed
        m_cell = f_mesenchyme_real_m(m_cell,c_x,c_y,c_xnew,c_ynew,c_xmes,c_ymes,m_allowed_mesenchyme_targets,v_parameters);
end