function c_nottrapped = f_mesenchyme_trapped_check_c(c_x,c_y,m_cell,c_xold,c_yold,v_parameters)
% A function which works out whether a given move results in a mesenchyme
% cell becoming 'trapped'; returning 1 if not trapped, and 0 if trapped.
% The definition of trapped is having more than c_mes_trapped neighbours.
% Here c_xold and c_yold refer to the location of the mesenchyme prior to
% the move (should now be one as is occupied (hypothetically) by a
% epithelium.) (c_x,c_y) is the proposed move location for the mesenchyme.

% Get all the 8-neighbouring cells for (c_x,c_y)
m_allindices = f_allindices_8neigh_m(c_x,c_y,v_parameters);


% Get the total number of moves available to the cell
c_numindices = length_new(m_allindices);

% Go through and check the cell moved from is one of the 8 NN
c_check = 0;
for i = 1:c_numindices
   if  [m_allindices(i,1),m_allindices(i,2)] == [c_xold,c_yold];
       c_check = 1;
   end 
end

if c_check == 0
    'An error has been made in f_mesenchyme_trapped_check_c. The cell position from which mesenchyme was moved is not in the list of NN cells.'
end

% Now go through all the indices and count the number of cells which are
% epithelium
c_epithelium_count = 0;

for i = 1:c_numindices
   if or(m_cell(m_allindices(i,1),m_allindices(i,2)) == 1,m_cell(m_allindices(i,1),m_allindices(i,2)) == 2)
       c_epithelium_count = c_epithelium_count + 1;
   end
end


% Return a 1 only if the number of nearest neighbours is less than or equal
% to c_mes_trapped
c_mes_trapped = v_parameters(18);
c_nottrapped = 0;

if c_epithelium_count <= c_mes_trapped
    c_nottrapped = 1;
end