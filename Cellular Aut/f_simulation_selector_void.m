function [] = f_simulation_selector_void(hObject,handles)
% A function which plots either the in vitro or in vivo simulation
% dependent on the handles

% Stop the currently running process
f_simulation_stop_void(hObject,handles);
pause(0.6)
refresh
% Update the parameters shown in boxes
f_parameters_visible(hObject,handles);


switch handles.c_simulation
    case 1
        f_invitro_plotter_void(hObject,handles)
    case 2
        f_invivo_plotter_void(hObject,handles)
end
