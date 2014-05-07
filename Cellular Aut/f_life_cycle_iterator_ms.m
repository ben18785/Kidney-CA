function [m_cell,m_GDNF] = f_life_cycle_iterator_ms(m_cell,m_GDNF,c_T,v_parameters)
% A function which iterates through discrete time steps of the model;
% updating the field and cells at each step.

c_mesen_tot = sum(sum(m_cell==-1));


% Go through the time steps 
for t = 1:c_T
    t
    c_mesen_running = sum(sum(m_cell==-1));
    if c_mesen_running ~=c_mesen_tot
        'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
        return;
    end
        
    m_cell = f_update_cells_m(m_cell,m_GDNF,v_parameters);
    m_GDNF = f_field_update_m(m_cell,v_parameters);
    subplot(1,2,1),imagesc(m_cell)
    title('Cell distribution')
    subplot(1,2,2),imagesc(m_GDNF)
    title('GDNF distribution')
    pause(0.01)
end