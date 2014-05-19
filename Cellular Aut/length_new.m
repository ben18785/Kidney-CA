function c_len = length_new(m_amatrix)
% A function which returns the length of an array as the number of entries
% in its first index

c_len = size(m_amatrix);
c_len = c_len(1);