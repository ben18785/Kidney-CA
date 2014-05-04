function [m_indices] = f_random_indices(m_indices)
% A function which randomises a matrix of indices across its rows (keeping
% each individual row entry associated with the particular column entry ie
% the coordinates)

% Calculate the length of the m_indices
c_indices = size(m_indices);
c_width = c_indices(2);
c_indices = c_indices(1);

% Now create a vector of random numbers so that we can randomly sort the
% epithelium cells
v_rand = rand(c_indices,1);

% Create a new matrix which stores the random numbers as its first column,
% then the indices in the second two columns
m_indices = [v_rand m_indices];
m_indices = sortrows(m_indices,1);
m_indices = m_indices(:,2:2+c_width-1);