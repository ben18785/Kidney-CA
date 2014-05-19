function m_new = remove_zeros(m_old)
% A function which removes the zero rows from a matrix

m_new = m_old(m_old(:,1)>0,:);