function [] = f_initialise_gui_void(handles)


% Hide the diagnostic panel
set(handles.uipanel5,'Visible','off')

% Hide the second panel
set(handles.uipanel10,'Visible','off')
set(handles.uipanel3,'Visible','on')

% Set the slider values and print off rounded numbers
set(handles.slider1,'Value',handles.ck_dg);
set(handles.slider2,'Value',handles.ck_gamma);
set(handles.slider3,'Value',handles.c_mesenchyme_density);
set(handles.slider7,'Value',handles.ckp_moveprob);
set(handles.slider8,'Value',handles.ck_moveprob_cons);
set(handles.slider16,'Value',handles.ck_move_norm_cons);
set(handles.slider19,'Value',handles.ck_move_norm_slope);
set(handles.slider20,'Value',handles.c_pmove_grad);
set(handles.slider21,'Value',handles.c_beta_mesmove);

if handles.ck_neighbours == 4
    set(handles.popupmenu4,'Value',1);
else
    set(handles.popupmenu4,'Value',2);
end
    
set(handles.popupmenu5,'Value',handles.ck_movement_rule);
set(handles.popupmenu6,'Value',handles.ck_moveprob_rule);
set(handles.popupmenu7,'Value',handles.ck_moving_rule);
set(handles.popupmenu15,'Value',handles.c_mes_movement);
set(handles.popupmenu17,'Value',handles.c_mes_allowed);


c_dg_rounded = num2str(handles.ck_dg);
c_gamma_rounded = num2str(handles.ck_gamma);
c_mes_rounded = num2str(100*handles.c_mesenchyme_density);
c_dg_num = findstr('.',c_dg_rounded);
c_gamma_num = findstr('.',c_gamma_rounded);
c_mes_num = findstr('.',c_mes_rounded);
if length(c_dg_num) > 0
    c_dg_rounded=c_dg_rounded(1:c_dg_num-1)
    set(handles.text3,'String',c_dg_rounded);
else
    set(handles.text3,'String',handles.ck_dg);
end
if length(c_gamma_num) > 0
    c_gamma_rounded = c_gamma_rounded(1:c_gamma_num-1);
    set(handles.text4,'String',c_gamma_rounded);
else
    set(handles.text4,'String',handles.ck_gamma);
end
if length(c_mes_num) > 0
    c_mes_rounded = c_mes_rounded(1:c_mes_num-1);
    c_mes_rounded = strcat(c_mes_rounded,'%');
    set(handles.text6,'String',c_mes_rounded);
else
    a = strcat(num2str(c_mes_rounded),'%')
    set(handles.text6,'String',a);
end
set(handles.text11,'String','0');

handles.c0 = handles.ck_moveprob_cons;
handles.c1 = handles.ck_move_norm_cons;
handles.c2 = handles.ck_move_norm_slope;
handles.c3 = handles.c_pmove_grad;
set(handles.text47,'String',num2str(handles.c0));
set(handles.text61,'String',num2str(handles.c1));
set(handles.text67,'String',num2str(handles.c2));
set(handles.text70,'String',num2str(handles.c3));
set(handles.text74,'Visible','off')
set(handles.text75,'Visible','off')
set(handles.text76,'Visible','off')
set(handles.text77,'Visible','off')
set(handles.text108,'String',num2str(handles.c_beta_mesmove));
set(handles.text110,'String',num2str(handles.v_parameters(18)));