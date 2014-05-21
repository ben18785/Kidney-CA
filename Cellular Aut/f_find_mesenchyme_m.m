function m_mesenchyme = f_find_mesenchyme_m(m_nearest,m_cell)
% A function which determines which of the indices given are mesenchyme,
% and returns a matrix with only those indices

cn_numindices = length_new(m_nearest);
m_mesenchyme = zeros(cn_numindices,2);

k = 1;
for i = 1:cn_numindices
    if m_cell(m_nearest(i,1),m_nearest(i,2)) == -1
        m_mesenchyme(k,:) = [m_nearest(i,1),m_nearest(i,2)];
        k = k + 1;
    end
end

% Remove zeros
m_mesenchyme = remove_zeros(m_mesenchyme);
