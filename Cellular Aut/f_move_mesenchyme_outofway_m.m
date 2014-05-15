function m_cell = f_move_mesenchyme_outofway_m(c_xmes,c_ymes,m_mesenchyme_available,m_cell,v_parameters)
% A function which moves a mesenchyme located at (c_xmes,c_ymes) to one of
% the available spots given in m_mesenchyme_available; choosing one at
% random

cn_nummoves = size(m_mesenchyme_available);
cn_nummoves = cn_nummoves(1);
if cn_nummoves == 0
    'error...there are no moves available to the mesenchyme! (f_move_mesenchyme_outofway_m)'
end

% If there is only one move, make it
if cn_nummoves == 1
    m_cell(c_xmes,c_ymes) = 0;
    m_cell(m_mesenchyme_available(1,1),m_mesenchyme_available(1,2)) = -1;
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
m_cell(c_xmes,c_ymes) = 0;
m_cell(m_mesenchyme_available(c_move_index,1),m_mesenchyme_available(c_move_index,2)) = -1;

