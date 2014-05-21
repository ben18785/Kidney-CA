% A predefined function for gui
function varargout = gui_CA2(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_CA2_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_CA2_OutputFcn, ...
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

% A function which executes on the opening of the gui
function gui_CA2_OpeningFcn(hObject, eventdata, handles, varargin)


% Specify basic simulation parameters governing time and initial location
% of epithelium and mesenchyme
handles.c_T = 100;

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
handles.c_mesenchyme_density = 0.1;
handles.c_depth_mesenstart = 1;
handles.c_width_mesenstart = 1;


% Specify the parameters in the v_parameters vector
handles.ck_dg = 100;
handles.ck_gamma = 1;
handles.ckp_moveprob = 0.5; % Probability of move vs proliferate. 1 means always move. 0 always proliferate
handles.ck_neighbours = 4; % Choose the number of nearest neighbours for movement/proliferation: 4 or 8
handles.ck_movement_rule = 8; % Choose a particular rule for allowed moves. 1 is allow all possible moves into vacant spots only; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the
% active cell); 4 allows movement into either a vacant space or a
% mesenchyme spot; 5 is the same as 2 but allows for movement into
% mesenchyme; 6 allows all moves and allows the movement into the
% mesenchyme iff there are available spots for the mesenchyme cell
handles.ck_moveprob_rule = 1; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_moveprob_cons = 1; % The constant used in rule 1 for P(move)
handles.ck_move_norm_cons = -150; % The constant to be used in the argument of the norm cdf function used in rule 2/3
handles.ck_move_norm_slope = 50; % The constant to be used to multiply the local GDNF concentration by in the argument to the normal cdf in rule 2/3
handles.ck_moving_rule = 7; % Select the type of move for probabilistically choosing between the available moves 
handles.c_pmove_grad = 10; %The coefficients used in targeting cells
% handles.c_target_cons = 0; % Another constant used in targeting cells
handles.ck_prolifprob_rule = handles.ck_moveprob_rule; % Select the type of rule to use for P(prolif). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
% if the concentration of GDNF is higher. 3 is for when the probability of
% a movement is dependent on the sum of all positive local GDNF gradients
handles.ck_prolif_choosecell_rule = handles.ck_moving_rule; % Select the type of move for probabilistically choosing between the available moves 
handles.c_beta_mesmove = -10; % A coefficient measuring the strength of discrimination against those moves for mesenchyme which are not in the direction they were pushed.
handles.c_mes_movement = 1; % Choose the rule for specifying the mesenchyme target cells. '1' means that the cells are chosen randomly. '2' means that the cells are chosen probabilistically weighted towards the direction they were pushed.
handles.c_mes_trapped = 8; % The maximum number of 8-nearest neighbour epithelium cells which can be neighbouring on a given mesenchyme cell after moving it. Aims to stop MM becoming trapped!
handles.c_mes_allowed = 1; % Choose the rule specifying whether a mesenchyme can occupy a spot. 1 means all vacant spots, 2 means only those spots which are connected less than c_mes_trapped
handles.c_principal = 5; % The maximum number of moves forward (from direction pushed) considered for mesenchyme if implementing non-local mesenchyme movement rule
handles.c_secondary = 2; % The maximum number of moves sideways (from direction pushed) considered for mesenchyme if implementing non-local mesenchyme movement rule

% Update handles structure
guidata(hObject, handles);
v_parameters = f_update_vparameters_void(hObject,handles); % A function which updates v_paramaters based on the parameters
handles.v_parameters = v_parameters;
guidata(hObject, handles);

% A function which initialises the gui sliders etc.
f_initialise_gui_void(handles)


% Choose default command line output for gui_CA2
handles.output = hObject;

% Initially choose image
handles.graph_selector = 0;
handles.diagnostics = 0;
handles.mesenchyme_old = 0;

% Update handles structure
guidata(hObject, handles);


f_simulation_selector_void(hObject,handles);


% Gui output function
function varargout = gui_CA2_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


% A menu which allows the user to specify the type of simulation to run; in
% vivo vs in vitro
function popupmenu1_Callback(hObject, eventdata, handles)


handles.c_simulation = get(hObject,'Value');
switch handles.c_simulation
    case 1
        f_invitro_plotter_void(hObject,handles)
    case 2
        f_invivo_plotter_void(hObject,handles)
end

% Update handles structure
guidata(hObject, handles);


% A menu which allows the user to specify the type of simulation to run; in
% vivo vs in vitro
function popupmenu1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A slider which allows the user to specify the diffusion rate
function slider1_Callback(hObject, eventdata, handles)

handles.ck_dg = get(hObject,'Value');
a = handles.ck_dg;

handles.v_parameters(1) = a;

% Update handles structure
guidata(hObject, handles);


f_simulation_selector_void(hObject,handles);

% A slider which allows the user to specify the diffusion rate
function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% A slider which allows the user to specify the relative rate of GDNF
% production to consumption
function slider2_Callback(hObject, eventdata, handles)

handles.ck_gamma = get(hObject,'Value');
handles.v_parameters(2) = handles.ck_gamma;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% A slider which allows the user to specify the relative rate of GDNF
% production to consumption
function slider2_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A slider which allows the user to specify the
% mesenchymal density
function slider3_Callback(hObject, eventdata, handles)

handles.c_mesenchyme_density = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A constructor for a slider which allows the user to specify the
% mesenchymal density
function slider3_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A pushbutton which allows the user to pause the simulation
function pushbutton2_Callback(hObject, eventdata, handles)

% Update handles structure
guidata(hObject, handles)
f_stopper_void(hObject,handles);

% A function which updates a handle which pauses the simulation
function f_stopper_void(hObject,handles)

handles = guidata(hObject);
handles.test1 = mod(handles.test1 + 1,2); % Let it alternate between 0 and 1
guidata(hObject,handles);


% A menu which allows the user to specify the number of
% nearest neighbours to consider: 4 or 8
function popupmenu4_Callback(hObject, eventdata, handles)

c_neighbours = get(hObject,'Value');
switch c_neighbours
    case 1
        handles.ck_neighbours = 4;
    case 2
        handles.ck_neighbours = 8;
end

handles.v_parameters(4) = handles.ck_neighbours;

% Update handles structure
guidata(hObject, handles);



f_simulation_selector_void(hObject,handles);


% A constructor for a menu which allows the user to specify the number of
% nearest neighbours to consider: 4 or 8
function popupmenu4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A menu which allows the user to specify the options for the allowed
% target cells
function popupmenu5_Callback(hObject, eventdata, handles)

c_movement_rule = get(hObject,'Value');
switch c_movement_rule
    case 1
        handles.ck_movement_rule  = 1;
    case 2
        handles.ck_movement_rule  = 2;
    case 3
        handles.ck_movement_rule  = 3;
    case 4
        handles.ck_movement_rule  = 4;
    case 5
        handles.ck_movement_rule  = 5;
    case 6
        handles.ck_movement_rule  = 6;
    case 7
        handles.ck_movement_rule  = 7;
    case 8
        handles.ck_movement_rule  = 8;
        
end

handles.v_parameters(5) = handles.ck_movement_rule;

% Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);


% A constructor for a menu which allows the user to specify the options for the allowed
% target cells
function popupmenu5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A function for a slider which allows the user to bias towards movement or
% proliferation
function slider7_Callback(hObject, eventdata, handles)

handles.ckp_moveprob = get(hObject,'Value');
handles.v_parameters(3) = handles.ckp_moveprob;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A constructor for a slider which allows the user to bias towards movement or
% proliferation
function slider7_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A function which allows the user to specify the form for
% Pr(move)
function popupmenu6_Callback(hObject, eventdata, handles)


c_moveprob = get(hObject,'Value');
switch c_moveprob
    case 1
        handles.ck_moveprob_rule  = 1;
    case 2
        handles.ck_moveprob_rule  = 2;
    case 3
        handles.ck_moveprob_rule  = 3;
end

handles.v_parameters(8) = handles.ck_moveprob_rule;

% Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);

% A constructor for a menu which allows the user to specify the form for
% Pr(move)
function popupmenu6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A function which allows the user to specify the form for
% Pr(proliferation)
function popupmenu7_Callback(hObject, eventdata, handles)

c_temp = get(hObject,'Value');
switch c_temp
    case 1
        handles.ck_moving_rule  = 1;
    case 2
        handles.ck_moving_rule  = 2;
    case 3
        handles.ck_moving_rule  = 3;
    case 4
        handles.ck_moving_rule  = 5; % This has been moved in order with the next case
    case 5
        handles.ck_moving_rule  = 4;
    case 6
        handles.ck_moving_rule  = 6;
    case 7
        handles.ck_moving_rule  = 7;
        
end



handles.v_parameters(12) = handles.ck_moving_rule;


% Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);

% A constructor for a menu which allows the user to specify the form for
% Pr(proliferation)
function popupmenu7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A constructor which allows the user to specify the choice of
% move target, allowing for the mesenchyme to be moved.
function popupmenu8_Callback(hObject, eventdata, handles)

c_moveprob = get(hObject,'Value');
switch c_moveprob
    case 1
        handles.ck_prolifprob_rule  = 1;
    case 2
        handles.ck_prolifprob_rule  = 2;
    case 3
        handles.ck_prolifprob_rule  = 3;
end

handles.v_parameters(14) = handles.ck_prolifprob_rule;

% Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);


% A constructor which allows the user to specify the choice of
% move target, allowing for the mesenchyme to be moved.
function popupmenu8_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A function which allows the user to specify the choice of
% proliferation target, allowing for the mesenchyme to be moved.
function popupmenu9_Callback(hObject, eventdata, handles)

c_temp = get(hObject,'Value');
switch c_temp
    case 1
        handles.ck_prolif_choosecell_rule  = 1;
    case 2
        handles.ck_prolif_choosecell_rule  = 2;
    case 3
        handles.ck_prolif_choosecell_rule  = 3;
    case 4
        handles.ck_prolif_choosecell_rule  = 5; % This and the next case have had their order changed
    case 5
        handles.ck_prolif_choosecell_rule  = 4;
    case 6
        handles.ck_prolif_choosecell_rule  = 6;
    case 7
        handles.ck_prolif_choosecell_rule  = 7;
end

handles.v_parameters(15) = handles.ck_prolif_choosecell_rule;

% Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);


% A constructor which allows the user to specify the choice of
% proliferation target, allowing for the mesenchyme to be moved.
function popupmenu9_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A function which allows the user to specify C0
function slider8_Callback(hObject, eventdata, handles)

handles.ck_moveprob_cons = get(hObject,'Value');
handles.v_parameters(9) = handles.ck_moveprob_cons;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% A constructor for a slider which allows the user to specify C0
function slider8_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A function which allows the user to specify C1
function slider16_Callback(hObject, eventdata, handles)

handles.ck_move_norm_cons = get(hObject,'Value');
handles.v_parameters(10) = handles.ck_move_norm_cons;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A constructor for a slider which allows the user to specify C1
function slider16_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A function which allows the user to specify C2
function slider19_Callback(hObject, eventdata, handles)

handles.ck_move_norm_slope = get(hObject,'Value');
handles.v_parameters(11) = handles.ck_move_norm_slope;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A constructor to allow the user to select C2
function slider19_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A function which allows the user to select the
% magnitude of target attraction for movement or proliferation
function slider20_Callback(hObject, eventdata, handles)

handles.c_pmove_grad = get(hObject,'Value');
handles.v_parameters(13) = handles.c_pmove_grad;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A constructor for creating the slider which allows the user to select the
% magnitude of target attraction for movement or proliferation
function slider20_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A function which when pressed brings up the diagnostic uipanel, and hides
% the panel there in the first place
function pushbutton8_Callback(hObject, eventdata, handles)
handles.diagnostics = mod(handles.diagnostics + 1,2);

if handles.diagnostics == 0
    set(handles.uipanel4,'Visible','on')
    set(handles.uipanel5,'Visible','off')
else
    set(handles.uipanel4,'Visible','off')
    set(handles.uipanel5,'Visible','on')
end

% Update handles structure
guidata(hObject, handles)



% A function which allows the user to select the
% move target (not allowing the mesenchyme to be moved).
function popupmenu10_Callback(hObject, eventdata, handles)

c_temp = get(hObject,'Value');
switch c_temp
    case 1
        handles.ck_moving_rule  = 1;
    case 2
        handles.ck_moving_rule  = 2;
    case 3
        handles.ck_moving_rule  = 3;
    case 4
        handles.ck_moving_rule  = 5; %This has been moved with the next
    case 5
        handles.ck_moving_rule  = 4;
    case 6
        handles.ck_moving_rule  = 6;
    case 7
        handles.ck_moving_rule  = 7;
        
end

handles.v_parameters(12) = handles.ck_moving_rule;


% Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);


% A function which creates the drop down box where the user can select the
% move target (not allowing the mesenchyme to be moved).
function popupmenu10_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% A function which creates the drop down box where the user can select the
% proliferation target (not allowing the mesenchyme to be moved).
function popupmenu11_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% A function which is triggered on user selecting the options from the
% dropdown box for the choice of proliferation target. This does not allow
% for options where the mesenchyme are moved.
function popupmenu11_Callback(hObject, eventdata, handles)


c_temp = get(hObject,'Value');
switch c_temp
    case 1
        handles.ck_prolif_choosecell_rule  = 1;
    case 2
        handles.ck_prolif_choosecell_rule  = 2;
    case 3
        handles.ck_prolif_choosecell_rule  = 3;
    case 4
        handles.ck_prolif_choosecell_rule  = 5; %This has been moved with next
    case 5
        handles.ck_prolif_choosecell_rule  = 4;
    case 6
        handles.ck_prolif_choosecell_rule  = 6;
    case 7
        handles.ck_prolif_choosecell_rule  = 7;
end

handles.v_parameters(15) = handles.ck_prolif_choosecell_rule;

% Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);




% A function which creates the graph selector button, which allows the user
% to specify the display.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% A function which chooses the type of graph to display, based on the
% user's selection
function popupmenu12_Callback(hObject, eventdata, handles)

c_temp = get(hObject,'Value');

% Update handles structure
guidata(hObject, handles)
handles = guidata(hObject);

switch c_temp
    case 1
        handles.graph_selector = 0;
    case 2
        handles.graph_selector = 1;
    case 3
        handles.graph_selector = 2;
    case 4
        handles.graph_selector = 3;
    case 5
        handles.graph_selector = 4;
    case 6
        handles.graph_selector = 5;
end

if handles.graph_selector == 0
    set(handles.text7,'String','Cell distribution');
    set(handles.text9,'String','GDNF distribution');
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','off')
    set(handles.text77,'Visible','off')
elseif handles.graph_selector == 1
    set(handles.text7,'String','Cell numbers');
    set(handles.text9,'String','Perimeter');
    set(handles.text74,'Visible','on')
    set(handles.text75,'Visible','on')
    set(handles.text76,'Visible','off')
    set(handles.text77,'Visible','off')
elseif handles.graph_selector == 2
    set(handles.text7,'String','Acceptance probability');
    set(handles.text9,'String','Target cell selection heterogeneity');
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','off')
    set(handles.text77,'Visible','off')
elseif handles.graph_selector == 3
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','on')
    set(handles.text77,'Visible','on')
    
else
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','off')
    set(handles.text77,'Visible','off')
    
end


guidata(hObject,handles);


% A pop up menu which allows the user to specify how the mesenchyme are
% moved by the epithelium cells
function popupmenu15_Callback(hObject, eventdata, handles)

c_temp = get(hObject,'Value');

switch c_temp
    case 1
        handles.c_mes_movement  = 1;
    case 2
        handles.c_mes_movement  = 2;
end
guidata(hObject,handles);
f_simulation_selector_void(hObject,handles);


% A pop up menu which allows the user to specify how the mesenchyme are
% moved by the epithelium cells
function popupmenu15_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A pop up menu which allows the user to open up the required box of options
% for the simulator
function popupmenu16_Callback(hObject, eventdata, handles)

c_temp = get(hObject,'Value');
switch c_temp
    case 1
        set(handles.uipanel10,'Visible','off')
        set(handles.uipanel3,'Visible','on')
    case 2
        set(handles.uipanel10,'Visible','on')
        set(handles.uipanel3,'Visible','off')
end


% A pop up menu which allows the user to open up the required box of options
% for the simulator
function popupmenu16_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A slider which allows the user to specify the strength of discrimination
% against mesenchyme targets not in the direction of movement of epithelium
% push
function slider21_Callback(hObject, eventdata, handles)
handles.c_beta_mesmove = get(hObject,'Value');
handles.v_parameters(16) = handles.c_beta_mesmove;
set(handles.text108,'String',num2str(handles.c_beta_mesmove));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

function slider21_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A function which changes the rule on the 
function popupmenu17_Callback(hObject, eventdata, handles)
    
c_temp = get(hObject,'Value');
    
    switch c_temp
        case 1
            handles.c_mes_allowed = 1;
        case 2
            handles.c_mes_allowed = 2;
    end

    handles.v_parameters(19) = handles.c_mes_allowed;

    % Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);


function popupmenu17_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Allows the user to specify the number of nearest neighbours which specify
% whether or not a moved mesenchyme is trapped.
function slider22_Callback(hObject, eventdata, handles)

handles.c_mes_trapped = round(get(hObject,'Value'));
handles.v_parameters(18) = handles.c_mes_trapped;
set(handles.text110,'String',num2str(handles.v_parameters(18)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to specify the number of nearest neighbours which specify
% whether or not a moved mesenchyme is trapped.
function slider22_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
