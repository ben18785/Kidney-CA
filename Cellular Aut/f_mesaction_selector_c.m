function ck_mes_action = f_mesaction_selector_c(v_parameters)
% A function which selects probabilistically between the actions available
% to a mesenchyme: moving, proliferation, differentiation and death

% Get the relative probabilities
ck_mes_move = v_parameters(22);
ck_mes_prolif = v_parameters(23);
ck_mes_diff = v_parameters(24);
ck_mes_death = v_parameters(25);

v_prob = [ck_mes_move; ck_mes_prolif; ck_mes_diff; ck_mes_death];

% Check that they sum to 1.
c_total = ck_mes_move + ck_mes_prolif + ck_mes_diff + ck_mes_death;

if c_total < 0.999 | c_total > 1.001
    'An error has been made with inputing the probabilities (in f_mesaction_selector)'
    return;
end

% Now creating the relevant intervals in the unit interval
m_intervals = zeros(4,2);
c_runninginterval = 0;
for i = 1:4
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + v_prob(i);
    m_intervals(i,2) = c_runninginterval;
end

% Now generating the random number to then compare to the interval matrix
cr_a = rand();

for i = 1:4
   if  cr_a > m_intervals(i,1) && cr_a < m_intervals(i,2)
       ck_mes_action = i;
       break;
   end
end
