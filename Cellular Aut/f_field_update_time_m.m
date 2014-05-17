function m_GDNF = f_field_update_time_m(m_cell,m_GDNF,v_parameters,c_delta_timestep)
% A function which updates the GDNF field according to the locations of the
% various cells by solving for the steady state of the diffusion equation

% Get the full dimensions
v_dimensions_full = size(m_cell);
c_width_full = v_dimensions_full(2);
c_depth_full = v_dimensions_full(1);

% First of all reshape m_GDNF into a vector
v_GDNF = zeros(c_width_full*c_depth_full,1);

for i = 1:c_depth_full
    for j = 1:c_width_full
        v_GDNF((i-1)*c_width_full + j) = m_GDNF(i,j);
    end
end

% Get the parameters v_parameters = [c_dg;c_gamma]
c_dg = v_parameters(1);
c_gamma = v_parameters(2);


% Create the laplacian with the correct dimensions and boundary conditions
[~,~,m_lap] =  laplacian([c_width_full c_depth_full],{'P' 'NN'});
m_lap = -m_lap;

% Now create the term dg * grad^2 g
v_rhs = c_dg*m_lap*v_GDNF;


v_rhs_extra = zeros(c_width_full*c_depth_full,1);

for i = 1:c_depth_full
    for j = 1:c_width_full
        switch m_cell(i,j)
            case -1 % Mesenchyme
                v_rhs_extra((i-1)*c_width_full+j) = -c_gamma;
            case 1 % Epithelium
                v_rhs_extra((i-1)*c_width_full+j) = v_GDNF((i-1)*c_width_full+j);
        end
    end
end

% Now combining the RHS terms
v_GDNF = c_delta_timestep*(v_rhs - v_rhs_extra) + v_GDNF;


% Reshape the field into a matrix
m_GDNF = zeros(c_depth_full,c_width_full);
for i = 1:c_depth_full
    for j = 1:c_width_full
        m_GDNF(i,j) = v_GDNF((i-1)*c_width_full + j);
    end
end

         