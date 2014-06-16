function [] = f_invivo_plotter_void(hObject,handles)
% A function which runs the simulation for the in vivo case

% Specify the parameters for the area
handles.c_depth_e = 20;
handles.c_separation = 20;
handles.c_depth_m = 20;
handles.c_width_mesenstart = 60;
handles.c_width_m = 80;
handles.c_depth_mesenstart = handles.c_depth_e+handles.c_separation;
guidata(hObject, handles);

% Update handles structure
guidata(hObject, handles);
v_parameters = f_update_vparameters_void(hObject,handles); % A function which updates v_paramaters based on the parameters
handles.v_parameters = v_parameters;
guidata(hObject, handles);

% Update the diagnostic box with the relevant parameters
f_diagnostic_guivis_void(handles);

% Print off the parameters to the screen
f_print_parameters_void(hObject,handles);


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
% Dependent on whether we are dealing with Ret dependency create epithelium
% accordingly
ck_ret_on = v_parameters(40);
switch ck_ret_on
    case 0 % No Ret dependence
        m_cell = f_create_epithelium_m(m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density);
    case 1 % Ret dependence
        m_cell = f_create_epithelium_ret_m(m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density,handles.v_parameters);
end
m_cell = f_create_mesenchyme_m(m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);

handles.m_mesenchyme_init = double(m_cell==-1);
guidata(hObject, handles);

% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,handles.v_parameters);


%% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
c_mesen_tot = sum(sum(m_cell==-1));

% Stop button!
handles = guidata(hObject);
handles.test1 = 0;

% Stop simulation initially zero (stops running before new sim starts)
handles.stop1 = 0;

guidata(hObject, handles);


f_simulation_calculation_plotter_void(m_cell,m_GDNF,c_mesen_tot,hObject,handles);
