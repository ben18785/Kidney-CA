function m_allindices = f_allindices_4neigh_m(c_x,c_y,v_parameters)
% A function which calculates the relevant neighbour indices for a cell at
% position (c_x,c_y) for 8 nearest neighbours

% Get the dimensions of the matrix being used
c_depth_full = v_parameters(6);
c_width_full = v_parameters(7);


% Only need to consider three cases if I use modular arithmetic due to
% periodic bc at left and right
% Need to transform y coordinates to span [0,c_width_full-1] in order to do
% modulo arithmetic
c_y = c_y - 1;

if and(c_x>1,c_x<c_depth_full) % In middle somewhere
    m_allindices = zeros(4,2);
    m_allindices(1,:) = [c_x,mod(c_y+1,c_width_full)]; % Right
    m_allindices(2,:) = [c_x,mod(c_y-1,c_width_full)]; % Left
    m_allindices(3,:) = [c_x+1,c_y]; % Above
    m_allindices(4,:) = [c_x-1,c_y]; % Below
elseif c_x == 1
    m_allindices = zeros(3,2);
    m_allindices(1,:) = [c_x,mod(c_y+1,c_width_full)]; % Right
    m_allindices(2,:) = [c_x,mod(c_y-1,c_width_full)]; % Left
    m_allindices(3,:) = [c_x+1,c_y]; % Above
elseif c_x == c_depth_full
    m_allindices = zeros(3,2);
    m_allindices(1,:) = [c_x,mod(c_y+1,c_width_full)]; % Right
    m_allindices(2,:) = [c_x,mod(c_y-1,c_width_full)]; % Left
    m_allindices(3,:) = [c_x-1,c_y]; % Below
end

% Transform y back
m_allindices(:,2) = m_allindices(:,2) + 1;



