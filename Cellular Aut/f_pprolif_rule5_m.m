function [c_heterogeneity,m_cell] = f_pprolif_rule5_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which chooses between the target cells and creates a daughter
% cells in one of them. In this rule the probability of one particular move is given by
% the multinomial logit distribution

cn_nummoves = size(m_allowedindices);
cn_nummoves = cn_nummoves(1);

% If there is only one move, make it
if cn_nummoves == 1
    c_heterogeneity = 0;
    m_cell(m_allowedindices(1,1),m_allowedindices(1,2)) = 1;
    return;
end


% Getting the parameters controlling the magnitude of the strength of the
% effect of gradients of GDNF on the probability of a particular move
c_pmove_grad = v_parameters(13);


% Calculate the denominator of the multinomial logit distribution
c_denominator = 0;
for i = 1:cn_nummoves
    c_denominator = c_denominator + exp(c_pmove_grad*(m_GDNF(m_allowedindices(i,1),m_allowedindices(i,2)) - m_GDNF(c_x,c_y)));
end


v_moves_prob = zeros(cn_nummoves,1);

% Calculate the individual probabilities
for i = 1:cn_nummoves
    v_moves_prob(i) = exp(c_pmove_grad*(m_GDNF(m_allowedindices(i,1),m_allowedindices(i,2)) - m_GDNF(c_x,c_y)))/c_denominator;
end
if sum(v_moves_prob) < 0.99
    'error'
end

% How much heterogeneity is there is choosing cells based on GDNF
% concentration?
c_hetero_numer = sum(v_moves_prob.^2)/cn_nummoves - (1/(cn_nummoves^2));
c_hetero_denom = (1/cn_nummoves) - (1/(cn_nummoves^2));
c_heterogeneity = c_hetero_numer/c_hetero_denom;


% Now creating intervals for the probabities in order to compare a random
% number and select finally the move
m_intervals = zeros(cn_nummoves,2);
c_runninginterval = 0;
for i = 1:cn_nummoves
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + v_moves_prob(i);
    m_intervals(i,2) = c_runninginterval;
end


% Now generating the random number to then compare to the interval matrix
cr_a = rand();

for i = 1:cn_nummoves
   if  cr_a > m_intervals(i,1) && cr_a < m_intervals(i,2)
       c_move_index = i;
       break;
   end
end

% Now implementing the move
m_cell(m_allowedindices(c_move_index,1),m_allowedindices(c_move_index,2)) = 1;

