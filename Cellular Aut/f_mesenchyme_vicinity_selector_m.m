function m_allmesenchyme = f_mesenchyme_vicinity_selector_m(c_xold,c_yold,c_xnew,c_ynew,m_cell,v_parameters)
% A function which chooses whether to just look for the 8 NN or all spaces
% in the vicinity for the mesenchyme. (c_xold,c_yold) is the current
% position of the epithelium which is moving to (c_xnew,c_ynew).

% The movement rule being used here
ck_movement_rule = v_parameters(5);



if ck_movement_rule ~= 8
    m_allmesenchyme = f_allindices_8neigh_m(c_xnew,c_ynew,v_parameters); % Find all possible available indices
    
elseif ck_movement_rule == 8 % If we are looking for all mesenchymal spaces in the vicinity
    [~,m_allmesenchyme] = f_allindices_allnearby_m(c_xold,c_yold,c_xnew,c_ynew,m_cell,v_parameters);
end