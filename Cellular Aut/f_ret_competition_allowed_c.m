function [c_allowed,m_index_GDNF_high] = f_ret_competition_allowed_c(c_x,c_y,m_cell,m_GDNF,v_parameters)
% A function which determines whether Ret competition can take place for a
% given Ret-h cell. It also returns the Ret-L cell with the highest GDNF
% concentration.

c_allowed = 0;
m_index_GDNF_high = zeros(1,2);

% First check that the cell is actually Ret-high
if m_cell(c_x,c_y) < 2
    'An error has been made whereby a Ret high cell was not passed to f_ret_competition_allowed_c'
end


%% Find all the neighbouring cells which are Ret-low

% First get all the indices
m_allindices = f_allindices_8neigh_m(c_x,c_y,v_parameters);


% Create a matrix of maximum length
cn_max = length_new(m_allindices);
m_allowed = zeros(cn_max,2);

k = 1;
for i = 1:cn_max
    if m_cell(m_allindices(i,1),m_allindices(i,2)) == 1
        m_allowed(k,:) = [m_allindices(i,1),m_allindices(i,2)];
        k = k + 1;
    end
end

% Remove excess zeros
m_allowed = remove_zeros(m_allowed);

%% Find any cells of those remaining which have GDNF higher than that of current cell position, and find the one with the highest GDNF gradient

% If there are no Ret-L neighbours then just return 0
if k == 1
    return;
end

cn_num = length_new(m_allowed);
c_grad = 0;
for i = 1:cn_num
    c_grad_new = m_GDNF(m_allowed(i,1),m_allowed(i,2)) - m_GDNF(c_x,c_y);
    if c_grad_new > 0
        c_allowed = 1;
        if c_grad_new > c_grad
            c_grad = c_grad_new;
            m_index_GDNF_high = [m_allowed(i,1),m_allowed(i,2)];
        end
    end
end

