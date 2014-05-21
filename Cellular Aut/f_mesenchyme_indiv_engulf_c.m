function c_nottrapped = f_mesenchyme_indiv_engulf_c(c_x,c_y,m_cell,v_parameters)
% A function which checks whether a mesenchyme at the position (c_x,c_y) is engulfed

% Get all the 8-neighbouring cells for (c_x,c_y)
m_allindices = f_allindices_8neigh_m(c_x,c_y,v_parameters);


% Get the total number of moves available to the cell
c_numindices = length_new(m_allindices);

% Now go through all the indices and count the number of cells which are
% epithelium
c_epithelium_count = 0;

for i = 1:c_numindices
   if m_cell(m_allindices(i,1),m_allindices(i,2)) == 1
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