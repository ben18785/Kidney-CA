function m_cell = f_pprolif_rule1_m(c_x,c_y,m_allowedindices,m_cell,m_GDNF,v_parameters)
% A function which chooses between the allowed movements and implements one
% of them for the daugter cell. In this rule the probability of one particular move is equal to
% 1/#moves; ie the same across all the available moves

cn_nummoves = size(m_allowedindices);
cn_nummoves = cn_nummoves(1);

% If there is only one move, make it
if cn_nummoves == 1
    m_cell(c_x,c_y) = 0;
    m_cell(m_allowedindices(1,1),m_allowedindices(1,2)) = 1;
    return;
end

% The probability increment for each of the moves is thus
c_pamove = 1/cn_nummoves;

% Now creating the relevant intervals in the unit interval
m_intervals = zeros(cn_nummoves,2);
c_runninginterval = 0;
for i = 1:cn_nummoves
    m_intervals(i,1) = c_runninginterval;
    c_runninginterval = c_runninginterval + c_pamove;
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

