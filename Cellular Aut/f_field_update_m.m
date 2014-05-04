function m_GDNF = f_field_update_m(m_cell,v_parameters)
% A function which updates the GDNF field according to the locations of the
% various cells by solving for the steady state of the diffusion equation

% Get the full dimensions
v_dimensions_full = size(m_cell);
c_width_full = v_dimensions_full(2);
c_depth_full = v_dimensions_full(1);

% Get the parameters v_parameters = [c_dg;c_gamma]
c_dg = v_parameters(1);
c_gamma = v_parameters(2);


% Create the laplacian with the correct dimensions and boundary conditions
[~,~,m_lap] =  laplacian([c_width_full c_depth_full],{'P' 'NN'});
m_lap = -m_lap;

% Modify the laplacian for each of the epithelial cells

for i = 1:c_depth_full
    for j = 1:c_width_full
        switch m_cell(i,j)
            case 1
                m_lap((i-1)*c_width_full+j,(i-1)*c_width_full+j) = m_lap((i-1)*c_width_full+j,(i-1)*c_width_full+j) - (1/c_dg); % It is minus for the second part because the matrix is already negative (if unsure check the Smallbone Matlab thing)
        end
    end
end
m_GDNF = m_lap;

% A test which checks a few diagonal values are what they should be by
% theory. IE the same as normal for non-epithelial cells, and adjusted
% otherwise
c_tests = 100;
a = f_laplacian_test_null(m_lap,m_cell,c_tests,c_depth_full,c_width_full,c_dg);
if a == 1
    'An error has been made with the Laplacian...'
    return;
end


% Create the RHS and modify the entries which correspond to the mesenchymal
% cells
v_rhs = zeros(c_width_full*c_depth_full,1);

for i = 1:c_depth_full
    for j = 1:c_width_full
        switch m_cell(i,j)
            case -1
                v_rhs((i-1)*c_width_full+j) = -c_gamma/c_dg;
        end
    end
end


% A test which checks that the correct elements of the v_rhs vector are
% being modified
b = f_vrhs_test_null(v_rhs,m_cell,c_tests,c_depth_full,c_width_full,c_dg,c_gamma);
if b == 1
    'An error has been made with the v_rhs...'
    return;
end

% Not calculate the field
v_GDNF = m_lap\v_rhs;
m_GDNF = zeros(c_depth_full,c_width_full);

% Reshape the field into a matrix
for i = 1:c_depth_full
    for j = 1:c_width_full
        m_GDNF(i,j) = v_GDNF((i-1)*c_width_full + j);
    end
end

         