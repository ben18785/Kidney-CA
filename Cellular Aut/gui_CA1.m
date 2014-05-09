function varargout = gui_CA1(varargin)
% GUI_CA1 MATLAB code for gui_CA1.fig
%      GUI_CA1, by itself, creates a new GUI_CA1 or raises the existing
%      singleton*.
%
%      H = GUI_CA1 returns the handle to a new GUI_CA1 or the handle to
%      the existing singleton*.
%
%      GUI_CA1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CA1.M with the given input arguments.
%
%      GUI_CA1('Property','Value',...) creates a new GUI_CA1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_CA1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_CA1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_CA1

% Last Modified by GUIDE v2.5 09-May-2014 12:43:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_CA1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_CA1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_CA1 is made visible.
function gui_CA1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_CA1 (see VARARGIN)
handles.c_simulation = 1;

switch handles.c_simulation
    case 1
        f_invitro_plotter_void(100,200,100,1,0.5,4,1,1,1,handles)
    case 2
        f_invivo_plotter_void(100,200,100,1,0.5,4,1,1,1,handles)
end





% Choose default command line output for gui_CA1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);





% UIWAIT makes gui_CA1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_CA1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function [] = f_invitro_plotter_void(c_T,c_size,ck_dg,ck_gamma,ckp_moveprob,ck_neighbours,ck_movement_rule,ck_moveprob_rule,ck_moving_rule,handles)
% A function which allows user to input parameters and plots the result


%% Parameters
% Specify the number of time cycles to iterate through
% c_T = 100;

% Specify the parameters for the area
% c_size = 200; 
c_width_full = c_size;
c_depth_full = c_size;
c_width_e = c_width_full;
c_width_m = c_width_full;
c_depth_e = 1;
c_separation = 0;
c_depth_m = c_size;
c_epithelium_density = 1; 
c_mesenchyme_density = 0.1;
c_depth_mesenstart = 1;
c_width_mesenstart = 1;


% Specify the parameters for solving the diffusion equation
% ck_dg = 100;
% ck_gamma = 1;
% ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
% ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
% ck_movement_rule = 1; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
% ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
c_pmove_grad = 10;
ck_prolifprob_rule = ck_moveprob_rule; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_prolif_choosecell_rule = ck_moving_rule; % Select the type of move for probabilistically choosing between the available moves 
v_parameters = [ck_dg;ck_gamma; ckp_moveprob; ck_neighbours;ck_movement_rule;c_depth_full;c_width_full;ck_moveprob_rule;ck_moveprob_cons;ck_move_norm_cons;ck_move_norm_slope;ck_moving_rule;c_pmove_grad;ck_prolifprob_rule;ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(c_width_full, c_depth_full);
m_cell = f_create_random_epithelium_m(m_cell, c_depth_full/2,c_width_full/2, 500,v_parameters);
m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart,c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);


%% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
c_mesen_tot = sum(sum(m_cell==-1));


% Go through the time steps 
for t = 1:c_T
    t
    c_mesen_running = sum(sum(m_cell==-1));
    if c_mesen_running ~=c_mesen_tot
        'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    end
        
    m_cell = f_update_cells_m(m_cell,m_GDNF,v_parameters);
    m_GDNF = f_field_update_m(m_cell,v_parameters);
    axes(handles.axes1)
    imagesc(m_cell)
    
    title('Cell distribution')
    axes(handles.axes2)
    imagesc(m_GDNF)
    
    title('GDNF distribution')
    pause(0.01)
end


function [] = f_invivo_plotter_void(c_T,c_size,ck_dg,ck_gamma,ckp_moveprob,ck_neighbours,ck_movement_rule,ck_moveprob_rule,ck_moving_rule,handles)
% A function which allows user to input parameters and plots the result


%% Parameters
% Specify the number of time cycles to iterate through
% c_T = 100;

% Specify the parameters for the area
% c_size = 200; 
c_width_full = c_size;
c_depth_full = c_size;
c_width_e = c_width_full;
c_width_m = c_width_full;
c_depth_e = 20;
c_separation = 10;
c_depth_m = 30;
c_epithelium_density = 1; 
c_mesenchyme_density = 0.1;
c_depth_mesenstart = c_depth_e+c_separation;
c_width_mesenstart = 1;


% Specify the parameters for solving the diffusion equation
% ck_dg = 100;
% ck_gamma = 1;
% ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
% ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
% ck_movement_rule = 1; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
% ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
c_pmove_grad = 10;
ck_prolifprob_rule = ck_moveprob_rule; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
ck_prolif_choosecell_rule = ck_moving_rule; % Select the type of move for probabilistically choosing between the available moves 
v_parameters = [ck_dg;ck_gamma; ckp_moveprob; ck_neighbours;ck_movement_rule;c_depth_full;c_width_full;ck_moveprob_rule;ck_moveprob_cons;ck_move_norm_cons;ck_move_norm_slope;ck_moving_rule;c_pmove_grad;ck_prolifprob_rule;ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(c_width_full, c_depth_full);
m_cell = f_create_epithelium_m(m_cell, c_width_e, c_depth_e, c_epithelium_density);
m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart,c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);


%% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
c_mesen_tot = sum(sum(m_cell==-1));


% Go through the time steps 
for t = 1:c_T
    t
    c_mesen_running = sum(sum(m_cell==-1));
    if c_mesen_running ~=c_mesen_tot
        'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    end
        
    m_cell = f_update_cells_m(m_cell,m_GDNF,v_parameters);
    m_GDNF = f_field_update_m(m_cell,v_parameters);
    axes(handles.axes1)
    imagesc(m_cell)
    
    title('Cell distribution')
    axes(handles.axes2)
    imagesc(m_GDNF)
    
    title('GDNF distribution')
    pause(0.01)
end


function [] = f_simulation_selector_void(handles)
% A function which plots either the in vitro or in vivo simulation
% dependent on the handles

switch handles.c_simulation
    case 1
        f_invitro_plotter_void(100,200,100,1,0.5,4,1,1,1,handles)
    case 2
        f_invivo_plotter_void(100,200,100,1,0.5,4,1,1,1,handles)
end





% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

handles.c_simulation = get(hObject,'Value');
switch handles.c_simulation
    case 1
        f_invitro_plotter_void(100,200,100,1,0.5,4,1,1,1,handles)
    case 2
        f_invivo_plotter_void(100,200,100,1,0.5,4,1,1,1,handles)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

