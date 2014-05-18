function [] = f_print_parameters_void(hObject,handles)
% A function which updates the parameters and prints them to the various
% boxes

% Update and round parameters to print them off
guidata(hObject, handles);
c_dg_rounded = num2str(handles.v_parameters(1));
c_gamma_rounded = num2str(handles.v_parameters(2));
c_mes_rounded = num2str(100*handles.c_mesenchyme_density);
c_dg_num = findstr('.',c_dg_rounded);
c_gamma_num = findstr('.',c_gamma_rounded)+2;
c_mes_num = findstr('.',c_mes_rounded);
if length(c_dg_num) > 0
    c_dg_rounded=c_dg_rounded(1:c_dg_num-1)
    set(handles.text3,'String',c_dg_rounded);
else
    set(handles.text3,'String',handles.v_parameters(1));
end
if length(c_gamma_num) > 0
    c_gamma_rounded = c_gamma_rounded(1:c_gamma_num-1);
    set(handles.text4,'String',c_gamma_rounded);
else
    set(handles.text4,'String',handles.v_parameters(2));
end
if length(c_mes_num) > 0
    c_mes_rounded = c_mes_rounded(1:c_mes_num-1);
    c_mes_rounded = strcat(c_mes_rounded,'%');
    set(handles.text6,'String',c_mes_rounded);
else
    a = strcat(num2str(c_mes_rounded),'%');
    set(handles.text6,'String',a);
end
set(handles.text6,'String',handles.c_mesenchyme_density);
set(handles.text25,'String',num2str(handles.v_parameters(4)));
set(handles.text23,'String',handles.v_parameters(3));


handles.c0 = handles.ck_moveprob_cons;
handles.c1 = handles.ck_move_norm_cons;
handles.c2 = handles.ck_move_norm_slope;
handles.c3 = handles.c_pmove_grad;
set(handles.text47,'String',num2str(handles.c0));
set(handles.text61,'String',num2str(handles.c1));
set(handles.text67,'String',num2str(handles.c2));
set(handles.text70,'String',num2str(handles.c3));

set(handles.slider3,'Value',handles.c_mesenchyme_density);
set(handles.text6,'String',num2str(handles.c_mesenchyme_density));
