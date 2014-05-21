function [c_allowed,m_allowedindices] = f_epithelium_mrule7_cm(c_x,c_y,m_allindices,m_cell,v_parameters,cp_move)
% A function which finds only those indices which allows moves if the
% active (moving) cell is not going to be unconnected. (c_x,c_y) is the
% current position of the epithelium cell. It also does not allow a move if
% the move results in a mesenchyme becoming trapped.

% The maximum number of allowed moves is the length of the index list
cd_indicesmax = length(m_allindices);
m_allowedindices = zeros(cd_indicesmax,2);


% Now loop through all indices,checking whether the cells are occupied by
% either mesenchyme or epithelium, and if moves are allowed
k = 1;
for i = 1:cd_indicesmax
    % Allow a move only if cell is nonvacant and cell which moves is not
    % disconnected after move
    switch cp_move
        case 1 % Moving
            if m_cell(m_allindices(i,1),m_allindices(i,2))==0 % If vacant, allow a move if it ensures the active cell is not unconnected
                c_allowed = f_epithelium_engulfment_c(m_allindices(i,1),m_allindices(i,2),m_cell,v_parameters);
                
                if and(f_activeconnected_c(c_x,c_y,m_allindices(i,1),m_allindices(i,2),m_cell,v_parameters)==1,c_allowed == 1)
                    m_allowedindices(k,:) = [m_allindices(i,1),m_allindices(i,2)];
                    k = k + 1;
                end
            elseif m_cell(m_allindices(i,1),m_allindices(i,2))== - 1 % If a mesenchyme, allow a movement iff there are vacant spots nearby for the mesenchyme to move into
                m_allmesenchyme = f_allindices_8neigh_m(m_allindices(i,1),m_allindices(i,2),v_parameters); % Find all possible available indices
                [c_allowed,~] = f_mesenchyme_available_cm(m_allindices(i,1),m_allindices(i,2),m_allmesenchyme,m_cell,v_parameters); % Check whether the moves are allowed
                
                if and(c_allowed==1,f_activeconnected_c(c_x,c_y,m_allindices(i,1),m_allindices(i,2),m_cell,v_parameters)==1)
                    m_allowedindices(k,:) = [m_allindices(i,1),m_allindices(i,2)];
                    k = k + 1;
                end
            end
        case 0 % Proliferating
            if m_cell(m_allindices(i,1),m_allindices(i,2))== 0 % If vacant, allow a move if it ensures the active cell is not unconnected
                c_allowed = f_epithelium_engulfment_c(m_allindices(i,1),m_allindices(i,2),m_cell,v_parameters);
                
                if and(f_activeconnected_proliferation_c(c_x,c_y,m_allindices(i,1),m_allindices(i,2),m_cell,v_parameters)==1,c_allowed == 1)
                    m_allowedindices(k,:) = [m_allindices(i,1),m_allindices(i,2)];
                    k = k + 1;
                end
               
            elseif m_cell(m_allindices(i,1),m_allindices(i,2))== - 1 % If a mesenchyme, allow a movement iff there are vacant spots nearby for the mesenchyme to move into
                m_allmesenchyme = f_allindices_8neigh_m(m_allindices(i,1),m_allindices(i,2),v_parameters); % Find all possible available indices
                [c_allowed,~] = f_mesenchyme_available_cm(m_allindices(i,1),m_allindices(i,2),m_allmesenchyme,m_cell,v_parameters); % Check whether the moves are allowed
                if and(f_activeconnected_proliferation_c(c_x,c_y,m_allindices(i,1),m_allindices(i,2),m_cell,v_parameters)==1,c_allowed == 1)
                    m_allowedindices(k,:) = [m_allindices(i,1),m_allindices(i,2)];
                    k = k + 1;
                end
            end
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