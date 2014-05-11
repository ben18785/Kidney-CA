function varargout = gui_startpage(varargin)
% GUI_STARTPAGE MATLAB code for gui_startpage.fig
%      GUI_STARTPAGE, by itself, creates a new GUI_STARTPAGE or raises the existing
%      singleton*.
%
%      H = GUI_STARTPAGE returns the handle to a new GUI_STARTPAGE or the handle to
%      the existing singleton*.
%
%      GUI_STARTPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_STARTPAGE.M with the given input arguments.
%
%      GUI_STARTPAGE('Property','Value',...) creates a new GUI_STARTPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_startpage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_startpage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_startpage

% Last Modified by GUIDE v2.5 11-May-2014 19:58:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_startpage_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_startpage_OutputFcn, ...
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


% --- Executes just before gui_startpage is made visible.
function gui_startpage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_startpage (see VARARGIN)

% Choose default command line output for gui_startpage
handles.output = hObject;


handles.s2= gui_CA1_2ndpage;
handles.s1= gui_CA1;

h1=guidata(handles.s1);
h1.next = handles.s2;
h1.prev = hObject;
guidata(handles.s1,h1);


h2=guidata(handles.s2);
h2.prev = handles.s1;
h2.next = hObject;
guidata(handles.s2,h2);

% Update handles structure
guidata(hObject, handles);
handles.output
%set(handles.output,'Visible','off');
set(handles.s1,'Visible','off');
set(handles.s2,'Visible','off');
guidata(hObject, handles);


% UIWAIT makes gui_startpage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_startpage_OutputFcn(hObject, eventdata, handles) 
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
set(handles.output,'Visible','off');
set(handles.s1,'Visible','on');
set(handles.s2,'Visible','off');
