function m_cellindices = f_update_cellindices_m(m_cellindices,m_cell_changes,m_cell)
% A function which updates the position of mesenchyme cells within
% m_cellindices according to the m_cell_changes matrix. Here
% c_cell_changes = [c_xold c_yold new_type_at_old_mesenchyme_pos; c_xnew
% c_ynew new_type_at_new_mesenchyme_pos]

if m_cell_changes(2,3) ~= -1
    'Non-mesenchyme at new position. An error has been made passing something to f_update_cellindices_m'
end

if and(m_cell_changes(2,3) ~= -1, m_cell_changes(1,3) ~= -1)
   'There are no mesenchyme at any positions in f_update_cellindices_m' 
end

% Return if the cell was the result of an active proliferation.
if m_cell_changes(1,3) == -1
        return; % No need to do anything here since the old position hasn't changed. We don't want to add the new cell to the list since that could lead to an infinite loop, plus we are only updating 
        % 1st generation cells in any particular loop.
end

% Iterate through and look for the row number which corresponds to the old
% position of the mesenchyme

% Find the length of m_cellindices
cn_indices = length_new(m_cellindices);

for i = 1:cn_indices
   % If the old indices match, update the matrix m_cellindices with the new
   % indices
   if and(m_cellindices(i,1) == m_cell_changes(1,1),m_cellindices(i,2) == m_cell_changes(1,2)) % Need an and here since each matrix has 3 columns (the last being type).
        m_cellindices(i,1) = m_cell_changes(2,1);
        m_cellindices(i,2) = m_cell_changes(2,2);
        m_cellindices(i,3) = m_cell_changes(2,3);
        
        if m_cell(m_cellindices(i,1),m_cellindices(i,2)) ~= m_cellindices(i,3)
            'An error has been made whereby a cell has been passed to f_update_cellindices_m which has type different to what is should'
            m_cell(m_cell_changes(1,1),m_cell_changes(1,2))
            m_cell(m_cellindices(i,1),m_cellindices(i,2))
            m_cellindices(i,3)
            m_cellindices(i,1)
            m_cellindices(i,2)
        end
        
        return;
   end
end
