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
c_depth_m = c_depth_full - c_depth_e;
c_epithelium_density = 0.9; 
c_mesenchyme_density = 0.1;
c_depth_mesenstart = c_depth_e+1;

% Specify the parameters for solving the diffusion equation
c_dg = 10;
c_gamma = 1;
v_parameters = [c_dg;c_gamma];

%% Create areas
% m_cell = f_create_area_m(c_width_full, c_depth_full);
% m_cell = f_create_epithelium_m(m_cell, c_width_e, c_depth_e, c_epithelium_density);
% m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart);
% % imagesc(m_cell)

% Create a test area of cells with a full N unit thick epithelium and some
% mesenchyme cells at the back
c_depth_testmesstart = c_depth_full-30;
c_depthlen_testmes = 5;
c_width_testmesstart = 10;
c_widthlen_test = 100;

m_cell = f_create_testarea_m(c_width_full,c_depth_full,c_depth_e,c_depth_testmesstart,c_depthlen_testmes,c_width_testmesstart,c_widthlen_test);

% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);


% Plot the initial GDNF field and the cell matrix
subplot(1,2,1),imagesc(m_cell)
title('Cell distribution')
subplot(1,2,2),imagesc(m_GDNF)
title('GDNF distribution')

