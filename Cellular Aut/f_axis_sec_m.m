function m_coords = f_axis_sec_m(c_xnew,c_ynew,c_prin_or_sec,v_delta,v_parameters)
% A function which returns all the points which lie along the secondary
% axis defined by v_delta_sec for the point (c_xnew,c_ynew). It should include
% only those coordinates that lie within the simulation domain

% Get the dimensions of the matrix being used
c_depth_full = v_parameters(6);
c_width_full = v_parameters(7);

% Create empty matrix to store results
m_coords = zeros(2*c_prin_or_sec+1,2);

k = 1;
for i = -c_prin_or_sec:c_prin_or_sec
    m_coords(k,1) = c_xnew + i*v_delta(1);
    if and(m_coords(k,1) > 0,m_coords(k,1) <= c_depth_full) % If acceptable x - find the y
        m_coords(k,2) = 1+mod(c_ynew + i*v_delta(2) - 1,c_width_full); % Modulo arithmetic therefore take 1 off. See 8-NN m file for a better example of its use
        k = k + 1; % Only increment k if the coordinate is added. Otherwise allow the next entry to write over it
    end
end

% Remove any remaining zero components
m_coords = remove_zeros(m_coords);
cn_coords = length_new(m_coords);

if m_coords(cn_coords,2) == 0 % If the last coordinate is a dud (hasn't been filled in), remove it
    m_coords(k,:) = [];
end
