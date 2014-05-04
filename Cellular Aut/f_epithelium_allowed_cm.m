function [c_allowed,m_allowedindices] = f_epithelium_allowed_cm(c_x,c_y,m_cell,v_parameters)
% A function which returns the allowed cell locations neighbouring on the
% active cell in question. Allows the use to specify the type of rules
% which are used via v_parameters.

% Get which particular rule to use here
ck_neighbours = v_parameters(4); 


% Whether to use 4 or 8 nearest neighbours
if ck_neighbours == 4
    % Get all potential indices
    m_allindices = f_allindices_4neigh_m(c_x,c_y,v_parameters);
    % Select the only relevant ones
    [c_allowed,m_allowedindices] = f_epithelium_allowedspecific_cm(c_x,c_y,m_allindices,m_cell,v_parameters);
    
elseif ck_neighbours == 8
    % Get all potential indices
    m_allindices = f_allindices_8neigh_m(c_x,c_y,v_parameters);
    % Select the only relevant ones
    [c_allowed,m_allowedindices] = f_epithelium_allowedspecific_cm(c_x,c_y,m_allindices,m_cell,v_parameters);
else
    'An error has been made. You either need to specify the number of nearest neighbours as 4 or 8'
end
    