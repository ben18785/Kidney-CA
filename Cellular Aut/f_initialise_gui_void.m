function [] = f_initialise_gui_void(handles)


% Dependent on whether Ret activity is being considered hide the irrelevant
% panels, update sliders with the correct value, and text boxes to do with
% Ret
if handles.ck_ret_on == 0
    set(handles.uipanel4,'Visible','on')
    set(handles.uipanel14,'Visible','off')
else
    set(handles.uipanel4,'Visible','off')
    set(handles.uipanel14,'Visible','on')
end

set(handles.popupmenu1,'Value',handles.c_simulation)
set(handles.slider35,'Value',handles.ck_moveprob_cons);
set(handles.slider36,'Value',handles.ck_moveprob_cons_rh);
set(handles.slider37,'Value',handles.ck_move_norm_cons);
set(handles.slider38,'Value',handles.ck_move_norm_cons_rh);
set(handles.slider39,'Value',handles.ck_move_norm_slope);
set(handles.slider40,'Value',handles.ck_move_norm_slope_rh);
set(handles.slider41,'Value',handles.c_pmove_grad);
set(handles.slider42,'Value',handles.c_pmove_grad_rh);
set(handles.text163,'String',num2str(handles.ck_moveprob_cons));
set(handles.text164,'String',num2str(handles.ck_moveprob_cons_rh));
set(handles.text166,'String',num2str(handles.ck_move_norm_cons));
set(handles.text167,'String',num2str(handles.ck_move_norm_cons_rh));
set(handles.text169,'String',num2str(handles.ck_move_norm_slope));
set(handles.text170,'String',num2str(handles.ck_move_norm_slope_rh));
set(handles.text172,'String',num2str(handles.c_pmove_grad));
set(handles.text173,'String',num2str(handles.c_pmove_grad_rh));
set(handles.popupmenu30,'Value',2-mod(1,handles.ck_ret_on));
set(handles.popupmenu31,'Value',handles.c_ret_transformation+1)

% Set the parameters in the Ret transform panel
set(handles.slider43,'Value',handles.ck_rh_num);
set(handles.text182,'String',num2str(handles.ck_rh_num));
set(handles.slider44,'Value',handles.c_retlh_prob);
set(handles.text183,'String',num2str(handles.c_retlh_prob));
set(handles.slider45,'Value',handles.c_rethl_prob);
set(handles.text184,'String',num2str(handles.c_rethl_prob));
set(handles.slider46,'Value',handles.c_retlh_prob_GDNF_C0);
set(handles.text188,'String',num2str(handles.c_retlh_prob_GDNF_C0));
set(handles.slider47,'Value',handles.c_retlh_prob_GDNF_C1);
set(handles.text189,'String',num2str(handles.c_retlh_prob_GDNF_C1));
set(handles.slider48,'Value',handles.c_rethl_prob_GDNF_C0);
set(handles.text193,'String',num2str(handles.c_rethl_prob_GDNF_C0));
set(handles.slider49,'Value',handles.c_reth1_prob_GDNF_C1);
set(handles.text194,'String',num2str(handles.c_reth1_prob_GDNF_C1));

% Hide the Ret competition panel
set(handles.uipanel18,'Visible','off')

% Set the various sliders etc. in the Ret competition panel to their
% correct positions
set(handles.popupmenu32,'Value',2-mod(1,handles.v_parameters(53)));
set(handles.popupmenu33,'Value',handles.v_parameters(56));
set(handles.slider50,'Value',handles.v_parameters(55));
set(handles.slider51,'Value',handles.v_parameters(57));
set(handles.slider52,'Value',handles.v_parameters(58));
set(handles.slider53,'Value',handles.v_parameters(59));
set(handles.text195,'String',num2str(handles.v_parameters(55)));
set(handles.text199,'String',num2str(handles.v_parameters(57)));
set(handles.text202,'String',num2str(handles.v_parameters(58)));
set(handles.text204,'String',num2str(handles.v_parameters(59)));

% Hide the diagnostic panel
set(handles.uipanel5,'Visible','off')

% Hide the second panel
set(handles.uipanel10,'Visible','off')
set(handles.uipanel3,'Visible','on')

% Hide the mesenchyme rules panel 1 and 2
set(handles.uipanel11,'Visible','off')
set(handles.uipanel12,'Visible','off')

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
set(handles.slider24,'Value',handles.v_parameters(20));
set(handles.slider25,'Value',handles.v_parameters(21));
set(handles.slider26,'Value',handles.v_parameters(22));
set(handles.slider27,'Value',handles.v_parameters(28));
set(handles.slider28,'Value',handles.v_parameters(32));
set(handles.slider29,'Value',handles.v_parameters(34));
set(handles.slider30,'Value',handles.v_parameters(36));
set(handles.slider31,'Value',handles.v_parameters(35));
set(handles.slider33,'Value',handles.v_parameters(38));
set(handles.slider34,'Value',handles.v_parameters(39));


set(handles.text133,'String',num2str(handles.v_parameters(28)));
set(handles.text134,'String',num2str(handles.v_parameters(32)));
set(handles.text137,'String',num2str(handles.v_parameters(34)));
set(handles.text138,'String',num2str(handles.v_parameters(36)));
set(handles.text140,'String',num2str(handles.v_parameters(35)));
set(handles.text141,'String',num2str(handles.v_parameters(37)));
set(handles.text155,'String',num2str(handles.v_parameters(38)));
set(handles.text156,'String',num2str(handles.v_parameters(39)));
set(handles.popupmenu19,'Value',handles.v_parameters(27));
set(handles.popupmenu20,'Value',handles.v_parameters(31));
set(handles.popupmenu26,'Value',handles.v_parameters(29));
set(handles.popupmenu27,'Value',handles.v_parameters(30));


 % Set the active mesenchyme popupmenu to the correct position
 set(handles.popupmenu24,'Value',handles.v_parameters(33)+1);

 % Initially hide the panel with Ret transformation options
 set(handles.uipanel17,'Visible','off')
 
 % Set various popups to correct position
 set(handles.popupmenu8,'Value',handles.ck_prolifprob_rule);


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
set(handles.text157,'Visible','off')
set(handles.text158,'Visible','off')
set(handles.text159,'Visible','off')
set(handles.text108,'String',num2str(handles.c_beta_mesmove));
set(handles.text110,'String',num2str(handles.v_parameters(18)));
set(handles.text116,'String',num2str(handles.v_parameters(20)));
set(handles.text117,'String',num2str(handles.v_parameters(21)));