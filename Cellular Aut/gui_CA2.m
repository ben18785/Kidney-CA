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
handles.c_T = 200;

handles.c_simulation = 2;
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
handles.ck_moveprob_rule = 2; % Select the type of rule to use for P(move). 1 for a constant probability of move. 2 for a rule in which the probability of a move increases
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
handles.c_beta_mesmove = -3; % A coefficient measuring the strength of discrimination against those moves for mesenchyme which are not in the direction they were pushed.
handles.c_mes_movement = 2; % Choose the rule for specifying the mesenchyme target cells. '1' means that the cells are chosen randomly. '2' means that the cells are chosen probabilistically weighted towards the direction they were pushed.
handles.c_mes_trapped = 8; % The maximum number of 8-nearest neighbour epithelium cells which can be neighbouring on a given mesenchyme cell after moving it. Aims to stop MM becoming trapped!
handles.c_mes_allowed = 1; % Choose the rule specifying whether a mesenchyme can occupy a spot. 1 means all vacant spots, 2 means only those spots which are connected less than c_mes_trapped
handles.c_principal = 10; % The maximum number of moves forward (from direction pushed) considered for mesenchyme if implementing non-local mesenchyme movement rule
handles.c_secondary = 2; % The maximum number of moves sideways (from direction pushed) considered for mesenchyme if implementing non-local mesenchyme movement rule

% Active mesenchyme parameters
handles.ck_mes_move = 0.1; % The probability of a mesenchyme choosing to go down branch corresponding to 'moving'. Not the same as moving, as it is yet to be determined whether the cell actually moves. Same for below 3. Local conditions and rules will determine if the action is actually taken.
handles.ck_mes_prolif = 0.9; % The probability of a mesenchyme choosing to go down branch corresponding to 'proliferating'
handles.ck_mes_diff = 0; % The probability of a mesenchyme choosing to go down branch corresponding to 'differentiating'
handles.ck_mes_death = 1 - handles.ck_mes_move - handles.ck_mes_prolif - handles.ck_mes_diff; % The probability of a mesenchyme choosing to go down branch corresponding to 'die'
handles.ck_mes_target_allowed = 1; % The rule to be used to determine those allowed cells which the mesenchyme can move into. 1 is local 8-NN if there are free cells.
handles.ck_mes_moveprob_rule = 2; % The rule used for P(mes move) in f_mes_move_prob_c
handles.ck_mes_moveprob_rule1_cons = 0; % The constant used for P(mes move) if rule 1 is selected in f_mes_move_prob_c
handles.ck_mes_move_target_rule = 2; % The rule used to select between targets for the moving mesenchyme in f_mes_move_cell
handles.ck_mes_prolif_target_rule = 2; % The rule used to select between target cells for the proliferating mesenchyme in f_mes_move_cell
handles.ck_mes_prolifprob_rule = 2;% The rule used for P(mes prolif) in f_mes_move_prob_c
handles.ck_mes_prolifprob_rule1_cons = 0; % The constant used for P(mes prolif) if rule 1 is selected in f_mes_move_prob_c
handles.c_turn_on_active_mesenchyme = 1; % A switch to allow the user to turn on or off the updating of the mesenchyme
handles.ck_mes_moveprob_rule2_discons_move_c1 = -10; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving
handles.ck_mes_moveprob_rule2_discons_move_c2 = 0; % A parameter specifying how much to weigh against mesenchyme distant from epithelium moving. Should be negative
handles.ck_mes_moveprob_rule2_discons_prolif_c1 = -1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating
handles.ck_mes_moveprob_rule2_discons_prolif_c2 = -0.1; % A parameter specifying how much to weigh against mesenchyme distant from epithelium proliferating. Should be negative
handles.ck_mes_move_target_disdiscrim = -10; % A negative parameter which governs the strength at which target cells (in moving a mesenchyme actively) which are further away from the mesenchyme are discriminated
handles.ck_mes_prolif_target_disdiscrim = -10; % A negative parameter which governs the strength at which target cells (in proliferating a mesenchyme actively) which are further away from the mesenchyme are discriminated


% Those parameters which are to do with Ret-high and Ret-low epithelium
handles.ck_ret_on = 1; % A parameter which either turns on (if it is 1) or turns off the Ret-high/low feature
handles.ck_rh_num = 0.1; % A parameter which specifies the proportion of initially created epithelium cells which are Ret-high
handles.ck_moveprob_cons_rh = handles.ck_moveprob_cons; % A parameter which determines the probability of a move occuring in f_probmove_rule1 if a cell is Ret-high
handles.ck_move_norm_cons_rh = handles.ck_move_norm_cons; % Constant C1 in rule f_probmove_rule2
handles.ck_move_norm_slope_rh = handles.ck_move_norm_slope; % Constant C2 in rule f_probmove_rule2
handles.c_pmove_grad_rh = handles.c_pmove_grad; % Ret-high parameter for f_pmoving_rule2; governing chemotaxtic movement
handles.c_ret_transformation = 0; % Rule selection for Ret-induced transformation of epithelium. See f_update_vparameters_void for a full description
handles.c_retlh_prob = 0.1; % retL->retH arbitrary probability
handles.c_rethl_prob = 0; % retH->retL arbitrary probability
handles.c_retlh_prob_GDNF_C0 = -10; % retL->retH GDNF probability constant
handles.c_retlh_prob_GDNF_C1 = 3; % retL->retH GDNF probability gradient
handles.c_rethl_prob_GDNF_C0 = 10; % retH->retL GDNF probability constant
handles.c_reth1_prob_GDNF_C1 = -10; % retH->retL GDNF probability gradient
handles.c_ret_competition = 1; % Ret competition rule selector. See f_update_vparameters_void for a full description
handles.c_ret_prob_rule = 1; % Ret competition probability rule. See f_update_vparameters_void for a full description
handles.c_ret_prob_rule1_cons = 0.9; % Probability of Ret competition occuring if above rule is '1'
handles.c_ret_comp_prob = 1; % P(comp) rule once this path has been started down
handles.c_ret_comp_prob_rule1_cons = 1; % The probability of competiting is a constant in rule 1 above
handles.c_ret_comp_prob_rule2_C0 = -3; % Constant used in rule 2
handles.c_ret_comp_prob_rule2_C1 = 5; % GDNF-multiplier constant used in rule 2


global error_count;
error_count = 0;

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
    case 7
        handles.graph_selector = 6;
    case 8
        handles.graph_selector = 7;
    case 9
        handles.graph_selector = 8;
end

if handles.graph_selector == 0
    set(handles.text7,'String','Cell distribution');
    set(handles.text9,'String','GDNF distribution');
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','off')
    set(handles.text77,'Visible','off')
    set(handles.text157,'Visible','off')
    set(handles.text158,'Visible','off')
    set(handles.text159,'Visible','off')
elseif handles.graph_selector == 1
    set(handles.text7,'String','Cell numbers');
    set(handles.text9,'String','Perimeter');
    if handles.ck_ret_on == 0
        set(handles.text74,'Visible','on')
        set(handles.text75,'Visible','on')
        set(handles.text157,'Visible','off')
        set(handles.text158,'Visible','off')
        set(handles.text159,'Visible','off')
        set(handles.text76,'Visible','off')
        set(handles.text77,'Visible','off')
    else
        set(handles.text74,'Visible','off')
        set(handles.text75,'Visible','off')
        set(handles.text157,'Visible','on')
        set(handles.text158,'Visible','on')
        set(handles.text159,'Visible','on')
        set(handles.text76,'Visible','off')
        set(handles.text77,'Visible','off')
    end
        
elseif handles.graph_selector == 2
    set(handles.text7,'String','Acceptance probability');
    set(handles.text9,'String','Target cell selection heterogeneity');
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','off')
    set(handles.text77,'Visible','off')
    set(handles.text157,'Visible','off')
    set(handles.text158,'Visible','off')
    set(handles.text159,'Visible','off')
elseif handles.graph_selector == 3
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','on')
    set(handles.text77,'Visible','on')
    set(handles.text157,'Visible','off')
    set(handles.text158,'Visible','off')
    set(handles.text159,'Visible','off')
else
    set(handles.text74,'Visible','off')
    set(handles.text75,'Visible','off')
    set(handles.text76,'Visible','off')
    set(handles.text77,'Visible','off')
    set(handles.text157,'Visible','off')
    set(handles.text158,'Visible','off')
    set(handles.text159,'Visible','off')
    
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
        set(handles.uipanel17,'Visible','off')
        set(handles.uipanel3,'Visible','on')
        set(handles.uipanel18,'Visible','off')
    case 2
        set(handles.uipanel10,'Visible','on')
        set(handles.uipanel17,'Visible','off')
        set(handles.uipanel3,'Visible','off')
        set(handles.uipanel18,'Visible','off')
    case 3
        set(handles.uipanel17,'Visible','on')
        set(handles.uipanel10,'Visible','off')
        set(handles.uipanel3,'Visible','off')
        set(handles.uipanel18,'Visible','off')
    case 4
        set(handles.uipanel17,'Visible','off')
        set(handles.uipanel10,'Visible','off')
        set(handles.uipanel3,'Visible','off')
        set(handles.uipanel18,'Visible','on')
        
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


% A function which allows the user to specify the maximum jump distance along the principal axis for
% mesenchyme in non-local jumping
function slider24_Callback(hObject, eventdata, handles)
handles.c_principal = round(get(hObject,'Value'));
handles.v_parameters(20) = handles.c_principal;
set(handles.text116,'String',num2str(handles.v_parameters(20)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% A function which allows the user to specify the maximum jump distance along the principal axis for
% mesenchyme in non-local jumping
function slider24_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% A function which allows the user to specify the maximum jump distance along the secondary axis for
% mesenchyme in non-local jumping
function slider25_Callback(hObject, eventdata, handles)
handles.c_secondary = round(get(hObject,'Value'));
handles.v_parameters(21) = handles.c_secondary;
set(handles.text117,'String',num2str(handles.v_parameters(21)));

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% A function which allows the user to specify the maximum jump distance along the secondary axis for
% mesenchyme in non-local jumping
function slider25_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Specify what probability to go down the moving branch vs the
% proliferation one
function slider26_Callback(hObject, eventdata, handles)
handles.ck_mes_move = get(hObject,'Value');
handles.v_parameters(22) = handles.ck_mes_move;
handles.ck_mes_prolif = 1 - handles.ck_mes_move;
handles.v_parameters(23) = handles.ck_mes_prolif;
set(handles.text129,'String',num2str(handles.v_parameters(22)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Specify what probability to go down the moving branch vs the
% proliferation one
function slider26_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A menu allowing the user to select the rule to use to calculate P(move)
function popupmenu19_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
    
    switch c_temp
        case 1
            handles.ck_mes_moveprob_rule = 1;
        case 2
            handles.ck_mes_moveprob_rule = 2;
    end

    handles.v_parameters(27) = handles.ck_mes_moveprob_rule;

    % Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);


% A menu allowing the user to select the rule to use to calculate P(move)
function popupmenu19_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A menu allowing the user to select the rule to use to calculate P(prolif)
function popupmenu20_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
    
    switch c_temp
        case 1
            handles.ck_mes_prolifprob_rule = 1;
        case 2
            handles.ck_mes_prolifprob_rule = 2;
    end

    handles.v_parameters(31) = handles.ck_mes_moveprob_rule;

    % Update handles structure
guidata(hObject, handles);

f_simulation_selector_void(hObject,handles);


% A menu allowing the user to select the rule to use to calculate P(prolif)
function popupmenu20_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A slider allowing the user to choose the parameter for rule 1 for P(move)
function slider27_Callback(hObject, eventdata, handles)
handles.ck_mes_moveprob_rule1_cons = get(hObject,'Value');
handles.v_parameters(28) = handles.ck_mes_moveprob_rule1_cons;

set(handles.text133,'String',num2str(handles.v_parameters(28)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A slider allowing the user to choose the parameter for rule 1 for P(move)
function slider27_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A slider allowing the user to choose the parameter for rule 1 for P(prolif)
function slider28_Callback(hObject, eventdata, handles)
handles.ck_mes_prolifprob_rule1_cons = get(hObject,'Value');
handles.v_parameters(32) = handles.ck_mes_prolifprob_rule1_cons;

set(handles.text134,'String',num2str(handles.v_parameters(32)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% A slider allowing the user to choose the parameter for rule 1 for P(prolif)
function slider28_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A slider allowing the user to choose the parameter C1 for rule 2 for P(move)
function slider29_Callback(hObject, eventdata, handles)
handles.ck_mes_moveprob_rule2_discons_move_c1 = get(hObject,'Value');
handles.v_parameters(34) = handles.ck_mes_moveprob_rule2_discons_move_c1;

set(handles.text137,'String',num2str(handles.v_parameters(34)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A slider allowing the user to choose the parameter C1 for rule 2 for P(move)
function slider29_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A slider allowing the user to choose the parameter C1 for rule 2 for P(Prolif)
function slider30_Callback(hObject, eventdata, handles)
handles.ck_mes_moveprob_rule2_discons_prolif_c1 = get(hObject,'Value');
handles.v_parameters(36) = handles.ck_mes_moveprob_rule2_discons_prolif_c1;

set(handles.text138,'String',num2str(handles.v_parameters(36)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);



% A slider allowing the user to choose the parameter C1 for rule 2 for P(Prolif)
function slider30_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A slider allowing the user to choose the parameter C2 for rule 2 for P(Move)
function slider31_Callback(hObject, eventdata, handles)
handles.ck_mes_moveprob_rule2_discons_move_c2 = get(hObject,'Value');
handles.v_parameters(35) = handles.ck_mes_moveprob_rule2_discons_move_c2;

set(handles.text140,'String',num2str(handles.v_parameters(35)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A slider allowing the user to choose the parameter C2 for rule 2 for P(Move)
function slider31_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A slider allowing the user to choose the parameter C2 for rule 2 for P(Prolif)
function slider32_Callback(hObject, eventdata, handles)
handles.ck_mes_moveprob_rule2_discons_prolif_c2 = get(hObject,'Value');
handles.v_parameters(37) = handles.ck_mes_moveprob_rule2_discons_prolif_c2;

set(handles.text141,'String',num2str(handles.v_parameters(37)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A slider allowing the user to choose the parameter C2 for rule 2 for P(Prolif)
function slider32_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% A slider which allows the user to specify the panel that they want to see
% for the mesenchyme 
function popupmenu23_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1
        set(handles.uipanel12,'Visible','off')
        set(handles.uipanel11,'Visible','off')
        set(handles.uipanel5,'Visible','off')
        if handles.ck_ret_on == 0
            set(handles.uipanel4,'Visible','on')
            set(handles.uipanel14,'Visible','off')
        else
            set(handles.uipanel4,'Visible','off')
            set(handles.uipanel14,'Visible','on')
        end
    case 2
        set(handles.uipanel12,'Visible','off')
        set(handles.uipanel11,'Visible','on')
        set(handles.uipanel5,'Visible','off')
        set(handles.uipanel4,'Visible','off')
        set(handles.uipanel14,'Visible','off')
    case 3
        set(handles.uipanel12,'Visible','on')
        set(handles.uipanel11,'Visible','off')
        set(handles.uipanel5,'Visible','off')
        set(handles.uipanel4,'Visible','off')
        set(handles.uipanel14,'Visible','off')
end

% A slider which allows the user to specify the panel that they want to see
% for the mesenchyme 
function popupmenu23_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Allows the user to specify whether or not to use active mesenchyme rules
function popupmenu24_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1 % off
        handles.c_turn_on_active_mesenchyme = 0;
    case 2 % On
        handles.c_turn_on_active_mesenchyme = 1;
       
end
handles.v_parameters(33) = handles.c_turn_on_active_mesenchyme;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to specify whether or not to use active mesenchyme rules
function popupmenu24_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A function which allows the user to specify the rules used to select
% between target cells for an actively moving mesenchyme
function popupmenu26_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1 
        handles.ck_mes_move_target_rule = 1;
    case 2 
        handles.ck_mes_move_target_rule = 2;
       
end
handles.v_parameters(29) = handles.ck_mes_move_target_rule;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);



% A function which allows the user to specify the rules used to select
% between target cells for an actively moving mesenchyme
function popupmenu26_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% A function which allows the user to specify the rules used to select
% between target cells for an actively proliferating the mesenchyme
function popupmenu27_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1 
        handles.ck_mes_prolif_target_rule = 1;
    case 2
        handles.ck_mes_prolif_target_rule = 2;
       
end
handles.v_parameters(30) = handles.ck_mes_move_target_rule;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% A function which allows the user to specify the rules used to select
% between target cells for an actively proliferating the mesenchyme
function popupmenu27_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Allows the user to select the strength of discrimination against target
% cells which are further away when moving the mesenchyme actively
function slider33_Callback(hObject, eventdata, handles)
handles.ck_mes_move_target_disdiscrim = get(hObject,'Value');
handles.v_parameters(38) = handles.ck_mes_move_target_disdiscrim;

set(handles.text155,'String',num2str(handles.v_parameters(38)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);



% Allows the user to select the strength of discrimination against target
% cells which are further away when moving the mesenchyme actively
function slider33_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows the user to select the strength of discrimination against target
% cells which are further away when proliferating the mesenchyme
function slider34_Callback(hObject, eventdata, handles)
handles.ck_mes_prolif_target_disdiscrim = get(hObject,'Value');
handles.v_parameters(39) = handles.ck_mes_prolif_target_disdiscrim;

set(handles.text156,'String',num2str(handles.v_parameters(39)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% Allows the user to select the strength of discrimination against target
% cells which are further away when proliferating the mesenchyme
function slider34_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-L constant for P(move/prolif) if rule 1 is
% chosen1
function slider35_Callback(hObject, eventdata, handles)
handles.ck_moveprob_cons = get(hObject,'Value');
handles.v_parameters(9) = handles.ck_moveprob_cons;

set(handles.text163,'String',num2str(handles.v_parameters(9)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows user to specify Ret-L constant for P(move/prolif) if rule 1 is
% chosen1
function slider35_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-H constant for P(move/prolif) if rule 1 is
% chosen1
function slider36_Callback(hObject, eventdata, handles)
handles.ck_moveprob_cons_rh = get(hObject,'Value');
handles.v_parameters(42) = handles.ck_moveprob_cons_rh;

set(handles.text164,'String',num2str(handles.v_parameters(42)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows user to specify Ret-H constant for P(move/prolif) if rule 1 is
% chosen1
function slider36_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-L C1 for P(move/prolif) if rule 2 is
% chosen1
function slider37_Callback(hObject, eventdata, handles)
handles.ck_move_norm_cons = get(hObject,'Value');
handles.v_parameters(10) = handles.ck_move_norm_cons;

set(handles.text166,'String',num2str(handles.v_parameters(10)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows user to specify Ret-L C1 for P(move/prolif) if rule 2 is
% chosen1
function slider37_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-H C1 for P(move/prolif) if rule 2 is
% chosen1
function slider38_Callback(hObject, eventdata, handles)
handles.ck_move_norm_cons_rh = get(hObject,'Value');
handles.v_parameters(43) = handles.ck_move_norm_cons_rh;

set(handles.text167,'String',num2str(handles.v_parameters(43)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows user to specify Ret-H C1 for P(move/prolif) if rule 2 is
% chosen1
function slider38_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-L C2 for P(move/prolif) if rule 2 is
% chosen1
function slider39_Callback(hObject, eventdata, handles)
handles.ck_move_norm_slope = get(hObject,'Value');
handles.v_parameters(11) = handles.ck_move_norm_slope;

set(handles.text169,'String',num2str(handles.v_parameters(11)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows user to specify Ret-L C2 for P(move/prolif) if rule 2 is
% chosen1
function slider39_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-H C2 for P(move/prolif) if rule 2 is
% chosen1
function slider40_Callback(hObject, eventdata, handles)
handles.ck_move_norm_slope_rh = get(hObject,'Value');
handles.v_parameters(44) = handles.ck_move_norm_slope_rh;

set(handles.text170,'String',num2str(handles.v_parameters(44)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows user to specify Ret-H C2 for P(move/prolif) if rule 2 is
% chosen1
function slider40_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-L chemotaxis strength
function slider41_Callback(hObject, eventdata, handles)
handles.c_pmove_grad = get(hObject,'Value');
handles.v_parameters(13) = handles.c_pmove_grad;

set(handles.text172,'String',num2str(handles.v_parameters(13)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% Allows user to specify Ret-L chemotaxis strength
function slider41_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows user to specify Ret-H chemotaxis strength
function slider42_Callback(hObject, eventdata, handles)
handles.c_pmove_grad_rh = get(hObject,'Value');
handles.v_parameters(45) = handles.c_pmove_grad_rh;

set(handles.text173,'String',num2str(handles.v_parameters(45)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows user to specify Ret-H chemotaxis strength
function slider42_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% A function which allows the user to turn on or off the Ret related
% activities
function popupmenu30_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1 
        handles.ck_ret_on = 0;
    case 2
        handles.ck_ret_on = 1;
       
end
handles.v_parameters(40) = handles.ck_ret_on;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% A function which allows the user to turn on or off the Ret related
% activities
function popupmenu30_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Allows the user to specify the initial proportion of Ret H cells in the
% starting epithelium
function slider43_Callback(hObject, eventdata, handles)
handles.ck_rh_num = get(hObject,'Value');
handles.v_parameters(41) = handles.ck_rh_num;

set(handles.text182,'String',num2str(handles.v_parameters(41)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to specify the initial proportion of Ret H cells in the
% starting epithelium
function slider43_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows the user to specify the rule to use for determining whether a
% Ret-L transforms into a Ret-H and vice versa
function popupmenu31_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1 
        handles.c_ret_transformation = 0;
    case 2
        handles.c_ret_transformation = 1;
    case 3
        handles.c_ret_transformation = 2;
    case 4
        handles.c_ret_transformation = 3;
    case 5
        handles.c_ret_transformation = 4;
       
end
handles.v_parameters(46) = handles.c_ret_transformation;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to specify the rule to use for determining whether a
% Ret-L transforms into a Ret-H and vice versa
function popupmenu31_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Allows the user to specify the probability for the transformation of
% Ret-L into Ret-H in rules 1 and 2 for transformation
function slider44_Callback(hObject, eventdata, handles)
handles.c_retlh_prob = get(hObject,'Value');
handles.v_parameters(47) = handles.c_retlh_prob;

set(handles.text183,'String',num2str(handles.v_parameters(47)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to specify the probability for the transformation of
% Ret-L into Ret-H in rules 1 and 2 for transformation
function slider44_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows the user to specify the probability for the transformation of
% Ret-H into Ret-L in rule 2 for transformation
function slider45_Callback(hObject, eventdata, handles)
handles.c_rethl_prob = get(hObject,'Value');
handles.v_parameters(48) = handles.c_rethl_prob;

set(handles.text184,'String',num2str(handles.v_parameters(48)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to specify the probability for the transformation of
% Ret-H into Ret-L in rule 2 for transformation
function slider45_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Constant C1 in Ret-L -> Ret-H transform rules 3 and 4
function slider46_Callback(hObject, eventdata, handles)
handles.c_retlh_prob_GDNF_C0 = get(hObject,'Value');
handles.v_parameters(49) = handles.c_retlh_prob_GDNF_C0;

set(handles.text188,'String',num2str(handles.v_parameters(49)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Constant C1 in Ret-L -> Ret-H transform rules 3 and 4
function slider46_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Constant C2 in Ret-L -> Ret-H transform rules 3 and 4
function slider47_Callback(hObject, eventdata, handles)
handles.c_retlh_prob_GDNF_C1 = get(hObject,'Value');
handles.v_parameters(50) = handles.c_retlh_prob_GDNF_C1;

set(handles.text189,'String',num2str(handles.v_parameters(50)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);

% Constant C2 in Ret-L -> Ret-H transform rules 3 and 4
function slider47_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Constant C1 in Ret-H -> Ret-L transform rule 4
function slider48_Callback(hObject, eventdata, handles)
handles.c_rethl_prob_GDNF_C0 = get(hObject,'Value');
handles.v_parameters(51) = handles.c_rethl_prob_GDNF_C0;

set(handles.text193,'String',num2str(handles.v_parameters(51)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Constant C1 in Ret-H -> Ret-L transform rule 4
function slider48_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Constant C2 in Ret-H -> Ret-L transform rule 4
function slider49_Callback(hObject, eventdata, handles)
handles.c_rethl_prob_GDNF_C1 = get(hObject,'Value');
handles.v_parameters(52) = handles.c_rethl_prob_GDNF_C1;

set(handles.text194,'String',num2str(handles.v_parameters(52)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Constant C2 in Ret-H -> Ret-L transform rule 4
function slider49_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows the user to specify the P(comp) vs move/proliferating
function slider50_Callback(hObject, eventdata, handles)
handles.c_ret_prob_rule1_cons = get(hObject,'Value');
handles.v_parameters(55) = handles.c_ret_prob_rule1_cons;

set(handles.text195,'String',num2str(handles.v_parameters(55)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);



% Allows the user to specify the P(comp) vs move/proliferating
function slider50_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows the user to turn on or off Ret competition
function popupmenu32_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1 
        handles.c_ret_competition = 0;
    case 2
        handles.c_ret_competition = 1;
end

handles.v_parameters(53) = handles.c_ret_competition;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to turn on or off Ret competition
function popupmenu32_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Allows the user to specify the arbitrary P(comp) if rule 1 is selected
% below
function slider51_Callback(hObject, eventdata, handles)
handles.c_ret_comp_prob_rule1_cons = get(hObject,'Value');
handles.v_parameters(57) = handles.c_ret_comp_prob_rule1_cons;

set(handles.text199,'String',num2str(handles.v_parameters(57)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);



% Allows the user to specify the arbitrary P(comp) if rule 1 is selected
% below
function slider51_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Allows the user to specify the rule used for P(comp)
function popupmenu33_Callback(hObject, eventdata, handles)
c_temp = get(hObject,'Value');
switch c_temp
    case 1 
        handles.c_ret_comp_prob = 1;
    case 2
        handles.c_ret_comp_prob = 2;
end

handles.v_parameters(56) = handles.c_ret_comp_prob;

% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Allows the user to specify the rule used for P(comp)
function popupmenu33_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% Alows the user to specify C1 if rule 2 is selected above in P(comp) = C1+
% C2*GDNFmaxgrad
function slider52_Callback(hObject, eventdata, handles)
handles.c_ret_comp_prob_rule2_C0 = get(hObject,'Value');
handles.v_parameters(58) = handles.c_ret_comp_prob_rule2_C0;

set(handles.text202,'String',num2str(handles.v_parameters(58)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Alows the user to specify C1 if rule 2 is selected above in P(comp) = C1+
% C2*GDNFmaxgrad
function slider52_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% Alows the user to specify C1 if rule 2 is selected above in P(comp) = C1+
% C2*GDNFmaxgrad
function slider53_Callback(hObject, eventdata, handles)
handles.c_ret_comp_prob_rule2_C1 = get(hObject,'Value');
handles.v_parameters(59) = handles.c_ret_comp_prob_rule2_C1;

set(handles.text204,'String',num2str(handles.v_parameters(59)));
% Update handles structure
guidata(hObject, handles)

f_simulation_selector_void(hObject,handles);


% Alows the user to specify C1 if rule 2 is selected above in P(comp) = C1+
% C2*GDNFmaxgrad
function slider53_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
