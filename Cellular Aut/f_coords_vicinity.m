function m_mesenchyme_starting = f_coords_vicinity(m_principal,v_delta_sec,v_parameters)
% A function which finds all the coordinates in the vicinity by
% sweeping along the secondary axis for all points that lie along the
% principal axis (and are provided already in m_principal)

cn_principal = length_new(m_principal);
c_secondary = v_parameters(21);

for i = 1:cn_principal
    if i == 1
        m_mesenchyme_starting = f_axis_sec_m(m_principal(i,1),m_principal(i,2),c_secondary,v_delta_sec,v_parameters);
    else
        m_temp = f_axis_sec_m(m_principal(i,1),m_principal(i,2),c_secondary,v_delta_sec,v_parameters);
        if length_new(m_temp) > 0
            m_mesenchyme_starting = [m_mesenchyme_starting; m_temp]; % Stack the coordinates
        end
    end
end