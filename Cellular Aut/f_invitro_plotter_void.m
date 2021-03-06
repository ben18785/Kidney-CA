function [] = f_invitro_plotter_void(hObject,handles)
% A function which runs the simulation for the in vitro case

% Diagnostic box visualisation
f_diagnostic_guivis_void(handles);



handles.c_simulation = 1;
handles.c_size = 200;
handles.c_width_full = handles.c_size;
handles.c_depth_full = handles.c_size;
handles.c_width_e = handles.c_width_full;
handles.c_width_m = handles.c_width_full;
handles.c_depth_e = 1;
handles.c_separation = 0;
handles.c_depth_m = handles.c_size;
handles.c_epithelium_density = 1; 
handles.c_depth_mesenstart = 1;
handles.c_width_mesenstart = 1;
handles.c_depth_e = 1;
handles.c_depth_m = handles.c_size;
handles.c_depth_mesenstart = 1;

% Update handles structure
guidata(hObject, handles);
v_parameters = f_update_vparameters_void(hObject,handles); % A function which updates v_paramaters based on the parameters
handles.v_parameters = v_parameters;
guidata(hObject, handles);



% Print off the parameters to the screen
f_print_parameters_void(hObject,handles);

%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
m_cell = f_create_random_epithelium_new_m(m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
m_cell = f_create_mesenchyme_m(m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);

handles.m_mesenchyme_init = double(m_cell==-1);
guidata(hObject, handles);
% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,handles.v_parameters);


% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
c_mesen_tot = sum(sum(m_cell==-1));

% Stop button!
handles = guidata(hObject);
handles.test1 = 0;

% Stop simulation initially zero (stops running before new sim starts)
handles.stop1 = 0;

guidata(hObject, handles);

% Create the acceptance and epithelium number vectors
v_acceptance = zeros(1,1);
v_epithelium = zeros(1,1);

% Create a vector of the numbers of mesenchyme
v_mesenchyme = zeros(1,1);

% Create a vector for measuring heterogeneity in target cell selection
% probabilities
v_heterogeneity = zeros(1,1);

% Create a vector to hold the perimeter
v_perimeter = zeros(1,1);

% Carry out the simulation and plot the results
f_simulation_calculation_plotter_void(m_cell,m_GDNF,c_mesen_tot,hObject,handles);
