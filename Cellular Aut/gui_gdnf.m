function varargout = gui_gdnf(varargin)
% GUI_GDNF MATLAB code for gui_gdnf.fig
%      GUI_GDNF, by itself, creates a new GUI_GDNF or raises the existing
%      singleton*.
%
%      H = GUI_GDNF returns the handle to a new GUI_GDNF or the handle to
%      the existing singleton*.
%
%      GUI_GDNF('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GDNF.M with the given input arguments.
%
%      GUI_GDNF('Property','Value',...) creates a new GUI_GDNF or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_gdnf_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_gdnf_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_gdnf

% Last Modified by GUIDE v2.5 02-May-2014 01:06:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_gdnf_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_gdnf_OutputFcn, ...
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


% --- Executes just before gui_gdnf is made visible.
function gui_gdnf_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_gdnf (see VARARGIN)
handles.c_width_full = 300;
handles.c_depth_full = 60;
handles.c_depth_e = 10;
handles.c_width_e = 300;
handles.c_depth_testmesstart = handles.c_depth_full-30;
handles.c_depthlen_testmes = 5;
handles.c_width_testmesstart = 10;
handles.c_widthlen_test = 100;


[m_cell,m_GDNF] = f_GDNF_test(handles.c_width_full,handles.c_depth_full,handles.c_depth_e,handles.c_width_e,handles.c_depth_testmesstart,handles.c_depthlen_testmes,handles.c_width_testmesstart,handles.c_widthlen_test);
handles.m_cell = m_cell;
handles_m_GDNF = m_GDNF;

% Display the cells first
axes(handles.axes1)
imagesc(m_cell)

% Display the GDNF concentration
axes(handles.axes2)
imagesc(m_GDNF)


% Choose default command line output for gui_gdnf
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_gdnf wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_gdnf_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.c_depth_testmesstart = round(get(handles.slider1,'Value'));

[m_cell,m_GDNF] = f_GDNF_test(handles.c_width_full,handles.c_depth_full,handles.c_depth_e,handles.c_width_e,handles.c_depth_testmesstart,handles.c_depthlen_testmes,handles.c_width_testmesstart,handles.c_widthlen_test);
handles.m_cell = m_cell;
handles_m_GDNF = m_GDNF;

% Display the cells first
axes(handles.axes1)
imagesc(m_cell)

% Display the GDNF concentration
axes(handles.axes2)
imagesc(m_GDNF)

% Update handles structure
guidata(hObject, handles);




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

handles.c_depthlen_testmes = round(get(handles.slider2,'Value'));

[m_cell,m_GDNF] = f_GDNF_test(handles.c_width_full,handles.c_depth_full,handles.c_depth_e,handles.c_width_e,handles.c_depth_testmesstart,handles.c_depthlen_testmes,handles.c_width_testmesstart,handles.c_widthlen_test);
handles.m_cell = m_cell;
handles_m_GDNF = m_GDNF;

% Display the cells first
axes(handles.axes1)
imagesc(m_cell)

% Display the GDNF concentration
axes(handles.axes2)
imagesc(m_GDNF)

% Update handles structure
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
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

handles.c_widthlen_test = round(get(handles.slider3,'Value'));

[m_cell,m_GDNF] = f_GDNF_test(handles.c_width_full,handles.c_depth_full,handles.c_depth_e,handles.c_width_e,handles.c_depth_testmesstart,handles.c_depthlen_testmes,handles.c_width_testmesstart,handles.c_widthlen_test);
handles.m_cell = m_cell;
handles_m_GDNF = m_GDNF;

% Display the cells first
axes(handles.axes1)
imagesc(m_cell)

% Display the GDNF concentration
axes(handles.axes2)
imagesc(m_GDNF)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.c_width_testmesstart = round(get(handles.slider4,'Value'));

[m_cell,m_GDNF] = f_GDNF_test(handles.c_width_full,handles.c_depth_full,handles.c_depth_e,handles.c_width_e,handles.c_depth_testmesstart,handles.c_depthlen_testmes,handles.c_width_testmesstart,handles.c_widthlen_test);
handles.m_cell = m_cell;
handles_m_GDNF = m_GDNF;

% Display the cells first
axes(handles.axes1)
imagesc(m_cell)

% Display the GDNF concentration
axes(handles.axes2)
imagesc(m_GDNF)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.c_depth_e = round(get(handles.slider5,'Value'));

[m_cell,m_GDNF] = f_GDNF_test(handles.c_width_full,handles.c_depth_full,handles.c_depth_e,handles.c_width_e,handles.c_depth_testmesstart,handles.c_depthlen_testmes,handles.c_width_testmesstart,handles.c_widthlen_test);
handles.m_cell = m_cell;
handles_m_GDNF = m_GDNF;

% Display the cells first
axes(handles.axes1)
imagesc(m_cell)

% Display the GDNF concentration
axes(handles.axes2)
imagesc(m_GDNF)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.c_width_e = round(get(handles.slider6,'Value'));

[m_cell,m_GDNF] = f_GDNF_test(handles.c_width_full,handles.c_depth_full,handles.c_depth_e,handles.c_width_e,handles.c_depth_testmesstart,handles.c_depthlen_testmes,handles.c_width_testmesstart,handles.c_widthlen_test);
handles.m_cell = m_cell;
handles_m_GDNF = m_GDNF;

% Display the cells first
axes(handles.axes1)
imagesc(m_cell)

% Display the GDNF concentration
axes(handles.axes2)
imagesc(m_GDNF)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
