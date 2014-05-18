function [] = f_diagnostic_guivis_void(handles)
% A function which updates the diagnostic box to reflect the choice of
% parameters selected by the individual

% Diagnostic box visualisation
set(handles.text26,'String',handles.v_parameters(1));
set(handles.text27,'String',handles.v_parameters(2));
set(handles.text28,'String',handles.v_parameters(3));
set(handles.text29,'String',handles.v_parameters(4));
set(handles.text30,'String',handles.v_parameters(5));
set(handles.text31,'String',handles.v_parameters(6));
set(handles.text32,'String',handles.v_parameters(7));
set(handles.text33,'String',handles.v_parameters(8));
set(handles.text34,'String',handles.v_parameters(9));
set(handles.text35,'String',handles.v_parameters(10));
set(handles.text36,'String',handles.v_parameters(11));
set(handles.text37,'String',handles.v_parameters(12));
set(handles.text38,'String',handles.v_parameters(13));
set(handles.text39,'String',handles.v_parameters(14));
set(handles.text40,'String',handles.v_parameters(15));
set(handles.text73,'String',handles.c_mesenchyme_density);
set(handles.text95,'String',handles.c_simulation);
set(handles.text97,'String',handles.c_mes_movement);