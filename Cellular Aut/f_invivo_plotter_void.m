function [] = f_invivo_plotter_void(hObject,handles)
% A function which runs the simulation for the in vivo case

% Specify the parameters for the area
handles.c_depth_e = 20;
handles.c_separation = 30;
handles.c_depth_m = 20;
handles.c_width_mesenstart = 100;
handles.c_width_m = 40;
handles.c_depth_mesenstart = handles.c_depth_e+handles.c_separation;
guidata(hObject, handles);

handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule;handles.c_beta_mesmove;handles.c_mes_movement];

% Update the diagnostic box with the relevant parameters
f_diagnostic_guivis_void(handles);

% Print off the parameters to the screen
f_print_parameters_void(hObject,handles);


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
m_cell = f_create_epithelium_m(m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density);
m_cell = f_create_mesenchyme_m(m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,handles.v_parameters);


%% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
c_mesen_tot = sum(sum(m_cell==-1));

% Stop button!
handles = guidata(hObject);
handles.test1 = 0;


guidata(hObject, handles);


f_simulation_calculation_plotter_void(m_cell,m_GDNF,c_mesen_tot,hObject,handles);
