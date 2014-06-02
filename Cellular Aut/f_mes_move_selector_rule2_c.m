function cell_measurables = f_mes_move_selector_rule2_c(c_x,c_y,m_allowedindices,m_cell,m_GDNF,m_distance,v_parameters,cp_move_or_prolif)
% A function which weights towards those moves which are closest to the
% epithelium. The mesenchyme is currently at (c_x,c_y).

cn_nummoves = size(m_allowedindices);
cn_nummoves = cn_nummoves(1);

% If there is only one move, make it
if cn_nummoves == 1
    c_heterogeneity = 0;
    cell_measurables = f_implement_mes_move_cell(1,m_cell,m_allowedindices,c_x,c_y,v_parameters,c_heterogeneity,cp_move_or_prolif);
    return;
end

% Calculate the differences in distance between the current cell and those
% which are available
v_distance = zeros(cn_nummoves,1);

for i = 1:cn_nummoves
    v_distance(i) = m_distance(m_allowedindices(i,1),m_allowedindices(i,2)) - m_distance(c_x,c_y);
end

% Getting the parameter for discriminating against those target cells which
% are further away from the epithelium
if cp_move_or_prolif == 1
    c_dis_dcrim = v_parameters(38);
else
    c_dis_dcrim = v_parameters(39);
end
    

% Calculate the denominator of the multinomial logit distribution
c_denominator = 0;
for i = 1:cn_nummoves
    c_denominator = c_denominator + exp(c_dis_dcrim*v_distance(i));
end

v_moves_prob = zeros(cn_nummoves,1);

% Calculate the individual probabilities
for i = 1:cn_nummoves
    v_moves_prob(i) = exp(c_dis_dcrim*v_distance(i))/c_denominator;
end
if sum(v_moves_prob) < 0.99
    'error'
end

% Now creating the relevant intervals in the unit interval
m_intervals = zeros(cn_nummoves,2);
c_runninginterval = 0;
for i = 1:cn_nummoves
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + v_moves_prob(i);
    m_intervals(i,2) = c_runninginterval;
end

c_hetero_numer = sum(v_moves_prob.^2)/cn_nummoves - (1/(cn_nummoves^2));
c_hetero_denom = (1/cn_nummoves) - (1/(cn_nummoves^2));
c_heterogeneity = c_hetero_numer/c_hetero_denom;



% Now generating the random number to then compare to the interval matrix
cr_a = rand();

for i = 1:cn_nummoves
   if  cr_a > m_intervals(i,1) && cr_a < m_intervals(i,2)
       c_move_index = i;
       break;
   end
end

% Now implementing the move
cell_measurables = f_implement_mes_move_cell(c_move_index,m_cell,m_allowedindices,c_x,c_y,v_parameters,c_heterogeneity,cp_move_or_prolif);