function [c_allowed,m_allowedindices] = f_epithelium_mrule2_cm(c_x,c_y,m_allindices,m_cell)
% A function which finds only those indices which allows moves if the
% active (moving) cell is not going to be unconnected

% The maximum number of allowed moves is the length of the index list
cd_indicesmax = length(m_allindices);
m_allowedindices = zeros(cd_indicesmax,2);

% Now loop through all indices,checking whether the cells are occupied by
% either mesenchyme or epithelium, and if moves are allowed
k = 1;
for i = 1:cd_indicesmax
    % Allow a move only if cell is nonvacant and cell which moves is not
    % disconnected after move
    if and(m_cell(m_allindices(i,1),m_allindices(i,2)) == 0,f_activeconnected_c(c_x,c_y,m_allindices(i,1),m_allindices(i,2),m_cell)==1)
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