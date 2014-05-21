function m_mesenchyme_starting = f_allindices_allnearby_all_m(c_xold,c_yold,c_xnew,c_ynew,m_cell,v_parameters)
% A function which finds all the available cells in the vicinity of
% (c_xnew,c_ynew) which holds a mesenchyme. A epithelium is moving from
% (c_xold,c_yold). The vicinity is defined by the parameters c_principal
% and c_secondary which define the maximum move length forward along the
% principal axis, and sideways along the secondary axis. A move of -1
% backwards is allowed if there are nearest neighbours either side (and
% backwards) of the MM.

% First of all find the direction of the principal axis
v_delta_move = f_delta_move_v(c_xold,c_yold,c_xnew,c_ynew,v_parameters);

% Get the dimensions of the search space to be considered
c_principal = v_parameters(20);
c_secondary = v_parameters(21);

% Then find all the moves available in a rectangular space starting one
% unit behind the mesenchyme and ending c_prinicpal in front of it. The
% width of the domain is c_secondary.

% Literally get all indices (using wrap around for width of domain), then
% check that all points are actually within the domain
m_mesenchyme_starting = zeros((c_principal+1)*2*c_secondary,2);

% Get the coordinates along the principal axis
m_principal = f_axis_coords_m(c_xnew,c_ynew,c_principal,v_delta_move,v_parameters);


% Now get the secondary axis components

% First find the secondary axis 'unit' vector
if v_delta_move == [1,1]
    v_delta_sec = [1,-1];
elseif v_delta_move == [1,0]
    v_delta_sec = [0,-1];
elseif v_delta_move == [0,1]
    v_delta_sec = [1,0];
elseif v_delta_move == [0,-1]
    v_delta_sec = [-1,0];
elseif v_delta_move == [-1,0]
    v_delta_sec = [0,1];
elseif v_delta_move == [-1,-1]
    v_delta_sec = [-1,1];
elseif v_delta_move == [1,-1]
    v_delta_sec = [-1,-1];
elseif v_delta_move == [-1,1]
    v_delta_sec = [1,1];
end

% Now get all the coordinate by working out all the coordinates along the
% secondary axis for each of the points on the principal axis
m_mesenchyme_starting = f_coords_vicinity(m_principal,v_delta_sec,v_parameters);
