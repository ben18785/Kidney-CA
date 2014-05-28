function m_GDNF = f_field_update_time_explicit_m(m_cell,m_GDNF,v_parameters,c_delta_timestep)
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
c_dg_time = 1500;
c_gamma = 1;


% Create the laplacian with the correct dimensions and boundary conditions
[~,~,m_lap] =  laplacian([c_width_full c_depth_full],{'P' 'NN'});
m_lap = -m_lap;

% Now creating the vector psi which contains the various terms for
% production and consumption
v_psi = zeros(c_depth_full*c_width_full,1);

k = 1;
for i = 1:c_depth_full
    for j = 1:c_width_full
        switch m_cell(i,j)
            case 1 % Epithelium
                v_psi(k) = m_GDNF(i,j)*(1/c_dg_time);
            case -1 % Mesenchyme
                v_psi(k) = -c_gamma/c_dg_time;
        end
        k = k + 1;
    end
end

% Now creating the RHS for the explicit case
v_GDNF = c_delta_timestep*(c_dg_time*m_lap*v_GDNF - v_psi) + v_GDNF;

% Reshape the field into a matrix
m_GDNF = zeros(c_depth_full,c_width_full);
for i = 1:c_depth_full
    for j = 1:c_width_full
        m_GDNF(i,j) = v_GDNF((i-1)*c_width_full + j);
    end
end

         