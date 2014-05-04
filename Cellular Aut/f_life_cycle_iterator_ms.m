function [m_cell,m_GDNF] = f_life_cycle_iterator_ms(m_cell,m_GDNF,c_T,v_parameters)
% A function which iterates through discrete time steps of the model;
% updating the field and cells at each step.

% Go through the time steps 
for t = 1:c_T
    m_cell = f_update_cells_m(m_cell,m_GDNF,v_parameters);
    m_GDNF = f_field_update_m(m_cell,v_parameters);
end