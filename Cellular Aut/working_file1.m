clear; close all; clc;

%% Parameters
% Specify the number of time cycles to iterate through
c_T = 100;

% Specify the parameters for the area
c_width_full = 300;
c_depth_full = 60;
c_width_e = c_width_full;
c_width_m = c_width_full;
c_depth_e = 10;
c_separation = 10;
c_depth_m = c_depth_full - c_depth_e-(c_separation-1);
c_epithelium_density = 0.8; 
c_mesenchyme_density = 0.3;
c_depth_mesenstart = c_depth_e+c_separation;

% Specify the parameters for solving the diffusion equation
c_dg = 10;
c_gamma = 10;
v_parameters = [c_dg;c_gamma];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(c_width_full, c_depth_full);
m_cell = f_create_epithelium_m(m_cell, c_width_e, c_depth_e, c_epithelium_density);
m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);

% Plot the initial GDNF field and the cell matrix
subplot(1,2,1),imagesc(m_cell)
title('Cell distribution')
subplot(1,2,2),imagesc(m_GDNF)
title('GDNF distribution')

%% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
% [m_cell,m_GDNF] = f_life_cycle_iterator_ms(m_cell,m_GDNF,c_T);