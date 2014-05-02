function [m_cell,m_GDNF] = f_GDNF_test(c_width_full,c_depth_full,c_depth_e,c_width_e,c_depth_testmesstart,c_depthlen_testmes,c_width_testmesstart,c_widthlen_test)
% A function which outputs matrices containing the cells and the GDNF
% concentration at each point. To be used in a GUI

%% Parameters
% Specify the number of time cycles to iterate through
c_T = 100;

% Specify the parameters for the area
c_width_full = 300;
c_depth_full = 60;
% c_width_e = c_width_full;
c_width_m = c_width_full;

c_depth_m = c_depth_full - c_depth_e;
c_epithelium_density = 0.9; 
c_mesenchyme_density = 0.1;
c_depth_mesenstart = c_depth_e+1;

% Specify the parameters for solving the diffusion equation
c_dg = 1e2;
c_gamma = 1;
v_parameters = [c_dg;c_gamma];

%% Create areas

% Create the mesenchyme and epithelium
m_cell = f_create_testarea_m(c_width_full,c_depth_full,c_depth_e,c_width_e,c_depth_testmesstart,c_depthlen_testmes,c_width_testmesstart,c_widthlen_test);

% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);
