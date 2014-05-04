function [c_allowed,m_allowedindices] = f_epithelium_mrule1_cm(c_x,c_y,m_allindices,m_cell)
% A function which finds only those indices which allows all possible moves
% if the cells are vacant

% The maximum number of allowed moves is the length of the index list
cd_indicesmax = length(m_allindices);
m_allowedindices = zeros(cd_indicesmax,2);

% Now loop through all indices,checking whether the cells are occupied by
% either mesenchyme or epithelium
k = 1;
for i = 1:cd_indicesmax
    if m_cell(m_allindices(i,1),m_allindices(i,2)) == 0 % If cell is vacant then add it to possible move locations
        m_allowedindices(k,:) = [m_allindices(i,1),m_allindices(i,2)];
        k = k + 1;
    end
end

if k == 1
    c_allowed = 0; % No allowed moves
    m_allowedindices=[];
    return;
end

c_allowed = 1; % There are allowed moves


% Get rid of the nonzero elements
m_allowedindices = [m_allowedindices(m_allowedindices(:,1)>0,1) m_allowedindices(m_allowedindices(:,1)>0,2)];
