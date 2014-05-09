function varargout = gui_CA(varargin)
% GUI_CA MATLAB code for gui_CA.fig
%      GUI_CA, by itself, creates a new GUI_CA or raises the existing
%      singleton*.
%
%      H = GUI_CA returns the handle to a new GUI_CA or the handle to
%      the existing singleton*.
%
%      GUI_CA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_CA.M with the given input arguments.
%
%      GUI_CA('Property','Value',...) creates a new GUI_CA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_CA_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_CA_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_CA

% Last Modified by GUIDE v2.5 09-May-2014 00:35:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_CA_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_CA_OutputFcn, ...
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


% --- Executes just before gui_CA is made visible.
function gui_CA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_CA (see VARARGIN)

handles.stop_button = 0;

handles.c_simulation = 1;

% Specify the number of time cycles to iterate through
handles.c_T = 100;

% Specify the parameters for the area
handles.c_size = 200; 
handles.c_width_full = handles.c_size;
handles.c_depth_full = handles.c_size;
handles.c_width_e = handles.c_width_full;
handles.c_width_m = handles.c_width_full;
handles.c_depth_e = 1;
handles.c_separation = 0;
handles.c_depth_m = handles.c_size;
handles.c_epithelium_density = 1; 
handles.c_mesenchyme_density = 0.1;
handles.c_depth_mesenstart = 1;
handles.c_width_mesenstart = 1;


% Specify the parameters for solving the diffusion equation
handles.ck_dg = 100;
handles.ck_gamma = 1;
handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 6; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10;
handles.ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = 6; % Select the type of move for probabilistically choosing between the available moves 
handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
handles.m_cell = f_create_random_epithelium_m(handles.m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
handles.m_cell = f_create_mesenchyme_m(handles.m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
handles.c_mesen_tot = sum(sum(handles.m_cell==-1));



% Now run the simulation
% for t = 1:handles.c_T
%     t
%     handles.c_mesen_running = sum(sum(handles.m_cell==-1));
%     if handles.c_mesen_running ~=handles.c_mesen_tot
%         'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
% %         return;
%     end
%         
%     handles.m_cell = f_update_cells_m(handles.m_cell,handles.m_GDNF,handles.v_parameters);
%     handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
%     axes(handles.axes1)
%     imagesc(handles.m_cell)
%     title('Cell distribution')
%     axes(handles.axes2)
%     imagesc(handles.m_GDNF)
%     title('GDNF distribution')
%     pause(0.01)
% end



% Choose default command line output for gui_CA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_CA wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_CA_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initially allow simulation to happen
% handles.stop_button = 0;

% Specify the number of time cycles to iterate through
handles.c_T = 100;

% Specify the parameters for the area
handles.c_size = 200; 
handles.c_width_full = handles.c_size;
handles.c_depth_full = handles.c_size;
handles.c_width_e = handles.c_width_full;
handles.c_width_m = handles.c_width_full;
handles.c_depth_e = 1;
handles.c_separation = 0;
handles.c_depth_m = handles.c_size;
handles.c_epithelium_density = 1; 
handles.c_mesenchyme_density = 0.1;
handles.c_depth_mesenstart = 1;
handles.c_width_mesenstart = 1;


% Specify the parameters for solving the diffusion equation
a = handles.ck_dg;
handles.ck_gamma = 1;
handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 6; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10;
% handles.ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = 6; % Select the type of move for probabilistically choosing between the available moves 
handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
handles.m_cell = f_create_random_epithelium_m(handles.m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
handles.m_cell = f_create_mesenchyme_m(handles.m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
handles.c_mesen_tot = sum(sum(handles.m_cell==-1));



% Now run the simulation if handles.stop_button = 0

for t = 1:handles.c_T
        handles.c_mesen_running = sum(sum(handles.m_cell==-1));
        if handles.c_mesen_running ~=handles.c_mesen_tot
            'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    %         return;
        end

        handles.m_cell = f_update_cells_m(handles.m_cell,handles.m_GDNF,handles.v_parameters);
        handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
        axes(handles.axes1)
        imagesc(handles.m_cell)
        title('Cell distribution')
        axes(handles.axes2)
%         imagesc(handles.m_GDNF)
        c = contour(flipud(handles.m_GDNF));
        clabel(c)
        title('GDNF distribution')
        pause(0.01)
        % Update handles structure
        guidata(hObject, handles);
end




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.stop_button,'UserData',1);
% Choose default command line output for gui_CA
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);




% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Specify the number of time cycles to iterate through
handles.c_T = 100;

% Specify the parameters for the area
handles.c_size = 200; 
handles.c_width_full = handles.c_size;
handles.c_depth_full = handles.c_size;
handles.c_width_e = handles.c_width_full;
handles.c_width_m = handles.c_width_full;
handles.c_depth_e = 1;
handles.c_separation = 0;
handles.c_depth_m = handles.c_size;
handles.c_epithelium_density = 1; 
handles.c_mesenchyme_density = 0.1;
handles.c_depth_mesenstart = 1;
handles.c_width_mesenstart = 1;


% Specify the parameters for solving the diffusion equation
handles.ck_dg = get(hObject,'Value');
handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
% handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 6; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10;
% handles.ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = 6; % Select the type of move for probabilistically choosing between the available moves 
handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
% Dependent on the type of simulation required - in vivo vs in vitro
switch handles.c_simulation
    case 1 % In vivo
        
        handles.c_width_full = 300;
        handles.c_depth_full = 60;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 20;
        handles.c_separation = 5;
        handles.c_depth_m = 50;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.5;
        handles.c_depth_mesenstart = handles.c_depth_e+handles.c_separation;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_epithelium_m(handles.m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density);

    case 2 % In vitro
        % Specify the number of time cycles to iterate through
        handles.c_T = 100;

        % Specify the parameters for the area
        handles.c_size = 200; 
        handles.c_width_full = handles.c_size;
        handles.c_depth_full = handles.c_size;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 1;
        handles.c_separation = 0;
        handles.c_depth_m = handles.c_size;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.1;
        handles.c_depth_mesenstart = 1;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_random_epithelium_m(handles.m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
end

handles.m_cell = f_create_mesenchyme_m(handles.m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
handles.c_mesen_tot = sum(sum(handles.m_cell==-1));



% Now run the simulation if handles.stop_button = 0

for t = 1:handles.c_T
        handles.c_mesen_running = sum(sum(handles.m_cell==-1));
        if handles.c_mesen_running ~=handles.c_mesen_tot
            'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    %         return;
        end

        handles.m_cell = f_update_cells_m(handles.m_cell,handles.m_GDNF,handles.v_parameters);
        handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
        axes(handles.axes1)
        imagesc(handles.m_cell)
        title('Cell distribution')
        axes(handles.axes2)
        c = contour(flipud(handles.m_GDNF));
        clabel(c)
        title('GDNF distribution')
        pause(0.01)
        % Update handles structure
        guidata(hObject, handles);
end



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
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

% Specify the number of time cycles to iterate through
handles.c_T = 100;

% Specify the parameters for the area
handles.c_size = 200; 
handles.c_width_full = handles.c_size;
handles.c_depth_full = handles.c_size;
handles.c_width_e = handles.c_width_full;
handles.c_width_m = handles.c_width_full;
handles.c_depth_e = 1;
handles.c_separation = 0;
handles.c_depth_m = handles.c_size;
handles.c_epithelium_density = 1; 
handles.c_mesenchyme_density = 0.1;
handles.c_depth_mesenstart = 1;
handles.c_width_mesenstart = 1;


% Specify the parameters for solving the diffusion equation
handles.ck_gamma = get(hObject,'Value');
handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
% handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 6; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10;
% handles.ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = 6; % Select the type of move for probabilistically choosing between the available moves 
handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
% Dependent on the type of simulation required - in vivo vs in vitro
switch handles.c_simulation
    case 1 % In vivo
        
        handles.c_width_full = 300;
        handles.c_depth_full = 60;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 20;
        handles.c_separation = 5;
        handles.c_depth_m = 50;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.5;
        handles.c_depth_mesenstart = handles.c_depth_e+handles.c_separation;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_epithelium_m(handles.m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density);

    case 2 % In vitro
        % Specify the number of time cycles to iterate through
        handles.c_T = 100;

        % Specify the parameters for the area
        handles.c_size = 200; 
        handles.c_width_full = handles.c_size;
        handles.c_depth_full = handles.c_size;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 1;
        handles.c_separation = 0;
        handles.c_depth_m = handles.c_size;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.1;
        handles.c_depth_mesenstart = 1;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_random_epithelium_m(handles.m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
end

handles.m_cell = f_create_mesenchyme_m(handles.m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
handles.c_mesen_tot = sum(sum(handles.m_cell==-1));



% Now run the simulation if handles.stop_button = 0

for t = 1:handles.c_T
        handles.c_mesen_running = sum(sum(handles.m_cell==-1));
        if handles.c_mesen_running ~=handles.c_mesen_tot
            'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    %         return;
        end

        handles.m_cell = f_update_cells_m(handles.m_cell,handles.m_GDNF,handles.v_parameters);
        handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
        axes(handles.axes1)
        imagesc(handles.m_cell)
        title('Cell distribution')
        axes(handles.axes2)
        c = contour(flipud(handles.m_GDNF));
        clabel(c)
        title('GDNF distribution')
        pause(0.01)
        % Update handles structure
        guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

a=get(h.checkbox,'value');

% get the value of the item you pressed
b=listboxinhoud(a);
b


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

handles.ck_moveprob_rule = get(hObject,'Value');
switch handles.ck_moveprob_rule
    case 1
        handles.ck_moveprob_rule = 1;
        handles.ck_prolifprob_rule = 1;
    case 2
        handles.ck_moveprob_rule = 2;
        handles.ck_prolifprob_rule = 2;
    case 3
        handles.ck_moveprob_rule = 3;
        handles.ck_prolifprob_rule = 3;
end

handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
% handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 6; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10;
% handles.ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = 6; % Select the type of move for probabilistically choosing between the available moves 
handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme


% Dependent on the type of simulation required - in vivo vs in vitro
switch handles.c_simulation
    case 1 % In vivo
        
        handles.c_width_full = 300;
        handles.c_depth_full = 60;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 20;
        handles.c_separation = 5;
        handles.c_depth_m = 50;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.5;
        handles.c_depth_mesenstart = handles.c_depth_e+handles.c_separation;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_epithelium_m(handles.m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density);

    case 2 % In vitro
        % Specify the number of time cycles to iterate through
        handles.c_T = 100;

        % Specify the parameters for the area
        handles.c_size = 200; 
        handles.c_width_full = handles.c_size;
        handles.c_depth_full = handles.c_size;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 1;
        handles.c_separation = 0;
        handles.c_depth_m = handles.c_size;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.1;
        handles.c_depth_mesenstart = 1;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_random_epithelium_m(handles.m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
end

handles.m_cell = f_create_mesenchyme_m(handles.m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
handles.c_mesen_tot = sum(sum(handles.m_cell==-1));



% Now run the simulation if handles.stop_button = 0

for t = 1:handles.c_T
        handles.c_mesen_running = sum(sum(handles.m_cell==-1));
        if handles.c_mesen_running ~=handles.c_mesen_tot
            'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    %         return;
        end

        handles.m_cell = f_update_cells_m(handles.m_cell,handles.m_GDNF,handles.v_parameters);
        handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
        axes(handles.axes1)
        imagesc(handles.m_cell)
        title('Cell distribution')
        axes(handles.axes2)
        c = contour(flipud(handles.m_GDNF));
        clabel(c)
        title('GDNF distribution')
        pause(0.01)
        % Update handles structure
        guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5

handles.ck_neighbours = get(hObject,'Value');
switch handles.ck_neighbours
    case 1
        handles.ck_neighbours = 4;
    case 2
        handles.ck_neighbours = 8;
end



% Specify the parameters for solving the diffusion equation
handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
% handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 6; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10;
% handles.ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = 6; % Select the type of move for probabilistically choosing between the available moves 
handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme


% Dependent on the type of simulation required - in vivo vs in vitro
switch handles.c_simulation
    case 1 % In vivo
        
        handles.c_width_full = 300;
        handles.c_depth_full = 60;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 20;
        handles.c_separation = 5;
        handles.c_depth_m = 50;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.5;
        handles.c_depth_mesenstart = handles.c_depth_e+handles.c_separation;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_epithelium_m(handles.m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density);

    case 2 % In vitro
        % Specify the number of time cycles to iterate through
        handles.c_T = 100;

        % Specify the parameters for the area
        handles.c_size = 200; 
        handles.c_width_full = handles.c_size;
        handles.c_depth_full = handles.c_size;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 1;
        handles.c_separation = 0;
        handles.c_depth_m = handles.c_size;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.1;
        handles.c_depth_mesenstart = 1;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_random_epithelium_m(handles.m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
end

handles.m_cell = f_create_mesenchyme_m(handles.m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
handles.c_mesen_tot = sum(sum(handles.m_cell==-1));



% Now run the simulation if handles.stop_button = 0

for t = 1:handles.c_T
        handles.c_mesen_running = sum(sum(handles.m_cell==-1));
        if handles.c_mesen_running ~=handles.c_mesen_tot
            'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    %         return;
        end

        handles.m_cell = f_update_cells_m(handles.m_cell,handles.m_GDNF,handles.v_parameters);
        handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
        axes(handles.axes1)
        imagesc(handles.m_cell)
        title('Cell distribution')
        axes(handles.axes2)
        c = contour(flipud(handles.m_GDNF));
        clabel(c)
        title('GDNF distribution')
        pause(0.01)
        % Update handles structure
        guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6

% Get the type of simulation - 1 for in vivo, 2 for in vitro
handles.c_simulation = get(hObject,'Value');





% Specify the parameters for solving the diffusion equation
handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 6; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
% handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 1; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10;
% handles.ck_prolifprob_rule = 2; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = 6; % Select the type of move for probabilistically choosing between the available moves 
handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme


% Dependent on the type of simulation required - in vivo vs in vitro
switch handles.c_simulation
    case 1 % In vivo
        
        handles.c_width_full = 300;
        handles.c_depth_full = 60;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 20;
        handles.c_separation = 5;
        handles.c_depth_m = 50;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.5;
        handles.c_depth_mesenstart = handles.c_depth_e+handles.c_separation;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_epithelium_m(handles.m_cell, handles.c_width_e, handles.c_depth_e, handles.c_epithelium_density);

    case 2 % In vitro
        % Specify the number of time cycles to iterate through
        handles.c_T = 100;

        % Specify the parameters for the area
        handles.c_size = 200; 
        handles.c_width_full = handles.c_size;
        handles.c_depth_full = handles.c_size;
        handles.c_width_e = handles.c_width_full;
        handles.c_width_m = handles.c_width_full;
        handles.c_depth_e = 1;
        handles.c_separation = 0;
        handles.c_depth_m = handles.c_size;
        handles.c_epithelium_density = 1; 
        handles.c_mesenchyme_density = 0.1;
        handles.c_depth_mesenstart = 1;
        handles.c_width_mesenstart = 1;
        handles.m_cell = f_create_area_m(handles.c_width_full, handles.c_depth_full);
        handles.m_cell = f_create_random_epithelium_m(handles.m_cell, handles.c_depth_full/2,handles.c_width_full/2, 500,handles.v_parameters);
end

handles.m_cell = f_create_mesenchyme_m(handles.m_cell, handles.c_width_m, handles.c_depth_m, handles.c_mesenchyme_density, handles.c_depth_mesenstart,handles.c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
handles.c_mesen_tot = sum(sum(handles.m_cell==-1));



% Now run the simulation if handles.stop_button = 0

for t = 1:handles.c_T
        handles.c_mesen_running = sum(sum(handles.m_cell==-1));
        if handles.c_mesen_running ~=handles.c_mesen_tot
            'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    %         return;
        end

        handles.m_cell = f_update_cells_m(handles.m_cell,handles.m_GDNF,handles.v_parameters);
        handles.m_GDNF = f_field_update_m(handles.m_cell,handles.v_parameters);
        axes(handles.axes1)
        imagesc(handles.m_cell)
        title('Cell distribution')
        axes(handles.axes2)
        c = contour(flipud(handles.m_GDNF));
        clabel(c)
        title('GDNF distribution')
        pause(0.01)
        % Update handles structure
        guidata(hObject, handles);
end




% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
