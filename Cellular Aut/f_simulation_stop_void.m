function f_simulation_stop_void(hObject,handles)
% A function which updates a handle which breaks the current simulation

handles = guidata(hObject);
handles.stop1 = 1; 
guidata(hObject,handles);