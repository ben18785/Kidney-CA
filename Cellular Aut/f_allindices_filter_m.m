function m_indices_filtered = f_allindices_filter_m(m_indices,m_cell)
% A function which goes through and removes all the cells which are
% currently occupied (by epithelium or MM) from the list m_indices

cn_numindices = length_new(m_indices);
m_indices_filtered = zeros(cn_numindices,2);

k = 1;
for i = 1:cn_numindices
    if m_cell(m_indices(i,1),m_indices(i,2)) == 0
        m_indices_filtered(k,:) = [m_indices(i,1),m_indices(i,2)];
        k = k + 1;
    end
end

% Remove the excess zeros
m_indices_filtered = remove_zeros(m_indices_filtered);