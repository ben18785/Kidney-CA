function c_move = f_mes_prob_rule2_c(c_x,c_y,m_allowedindices,m_cell,m_distance,v_parameters,ck_mes_moveprob_rule2_c1,ck_mes_moveprob_rule2_c2)
% A function which works out the distance of the mesenchyme at (c_x,c_y) to
% the nearest epithelium, and undertakes an action (a move or
% proliferation) with a probability that is inversely related to distance.

% Check that the distance matrix passed to it isn't null (this is a sign
% that in f_update_cells_m the distance matrix isn't being calculated
if length(m_distance) == 0
    'An error has been made whereby the m_distance matrix passed to f_mes_prob_rule2_c is null'
    return;
end

% Find the distance of the mesenchyme to the nearest epithelium
c_dist = m_distance(c_x,c_y);

% Now map this to (0,1) with a strength given by ck_mes_moveprob_rule2_discons
c_dist_prob = normcdf(ck_mes_moveprob_rule2_c1 + ck_mes_moveprob_rule2_c2*c_dist);

% Now probabilistically choose whether or not to move
c_move = f_mes_prob_rule1_c(c_x,c_y,m_allowedindices,v_parameters,c_dist_prob);
