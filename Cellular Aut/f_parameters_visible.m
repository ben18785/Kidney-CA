function f_parameters_visible(hObject,handles)
% Update handles structure
guidata(hObject, handles)

% Update some of the handles
set(handles.slider22,'Value',handles.v_parameters(18));

% Update with the ret panel hidden if necessary
if handles.ck_ret_on == 0
    set(handles.uipanel4,'Visible','on')
    set(handles.uipanel14,'Visible','off')
else
    set(handles.uipanel4,'Visible','off')
    set(handles.uipanel14,'Visible','on')
end

% Set the visibility correctly for the Ret P(move/prolif) and chemotaxis
% buttons
if and(handles.ck_moveprob_rule == 1, handles.ck_prolifprob_rule == 1)
    set(handles.slider35,'Visible','on');
    set(handles.slider36,'Visible','on');
    set(handles.text163,'Visible','on');
    set(handles.text164,'Visible','on');
    set(handles.slider37,'Visible','off');
    set(handles.slider38,'Visible','off');
    set(handles.slider39,'Visible','off');
    set(handles.slider40,'Visible','off');
    set(handles.text166,'Visible','off');
    set(handles.text167,'Visible','off');
    set(handles.text169,'Visible','off');
    set(handles.text170,'Visible','off');
    
elseif or(handles.ck_moveprob_rule == 1,handles.ck_prolifprob_rule == 1)
    set(handles.slider35,'Visible','on');
    set(handles.slider36,'Visible','on');
    set(handles.text163,'Visible','on');
    set(handles.text164,'Visible','on');
    set(handles.slider37,'Visible','on');
    set(handles.slider38,'Visible','on');
    set(handles.slider39,'Visible','on');
    set(handles.slider40,'Visible','on');
    set(handles.text166,'Visible','on');
    set(handles.text167,'Visible','on');
    set(handles.text169,'Visible','on');
    set(handles.text170,'Visible','on');
else
    set(handles.slider35,'Visible','off');
    set(handles.slider36,'Visible','off');
    set(handles.text163,'Visible','off');
    set(handles.text164,'Visible','off');
    set(handles.slider37,'Visible','on');
    set(handles.slider38,'Visible','on');
    set(handles.slider39,'Visible','on');
    set(handles.slider40,'Visible','on');
    set(handles.text166,'Visible','on');
    set(handles.text167,'Visible','on');
    set(handles.text169,'Visible','on');
    set(handles.text170,'Visible','on');
end

% Now doing the same for chemotaxis Ret sliders and text boxes
if and(or(handles.ck_moving_rule==1,handles.ck_moving_rule==7),or(handles.ck_prolif_choosecell_rule==1,handles.ck_prolif_choosecell_rule==7))
    set(handles.slider41,'Visible','off');
    set(handles.slider42,'Visible','off');
    set(handles.text172,'Visible','off');
    set(handles.text173,'Visible','off');
else
    set(handles.slider41,'Visible','on');
    set(handles.slider42,'Visible','on');
    set(handles.text172,'Visible','on');
    set(handles.text173,'Visible','on');
end


% Only allow the popup menu to allow the user to select active mesenchyme rules to be 
% selected if we are actually using active mesenchyme
if handles.v_parameters(33) == 1
    set(handles.text145,'Visible','on')
    set(handles.popupmenu23,'Visible','on')
else
    set(handles.text145,'Visible','off')
    set(handles.popupmenu23,'Visible','off')
end
    
        
% Only show the relevant buttons in the mesenchyme rules box if the correct
% rule is selected
% P(move) mesenchyme
if handles.v_parameters(27) == 1 
    set(handles.slider27,'Visible','on')
    set(handles.text133,'Visible','on')
    set(handles.text142,'Visible','off') %C1
    set(handles.slider29,'Visible','off')
    set(handles.text137,'Visible','off')
    set(handles.text143,'Visible','off') %C2
    set(handles.slider31,'Visible','off')
    set(handles.text140,'Visible','off')
elseif handles.v_parameters(27) == 2 
    set(handles.slider27,'Visible','off')
    set(handles.text133,'Visible','off')
    set(handles.text142,'Visible','on') %C1
    set(handles.slider29,'Visible','on')
    set(handles.text137,'Visible','on')
    set(handles.text143,'Visible','on') %C2
    set(handles.slider31,'Visible','on')
    set(handles.text140,'Visible','on')
end

% P(Prolif) mesenchyme
if handles.v_parameters(31) == 1 
    set(handles.slider28,'Visible','on')
    set(handles.text134,'Visible','on')
    set(handles.slider30,'Visible','off')
    set(handles.text138,'Visible','off')
    set(handles.slider32,'Visible','off')
    set(handles.text141,'Visible','off')
    set(handles.text142,'Visible','off') %C1
    set(handles.text143,'Visible','off') %C2
elseif handles.v_parameters(31) == 2
    set(handles.slider28,'Visible','off')
    set(handles.text134,'Visible','off')
    set(handles.slider30,'Visible','on')
    set(handles.text138,'Visible','on')
    set(handles.slider32,'Visible','on')
    set(handles.text141,'Visible','on')
    set(handles.text142,'Visible','on') %C1
    set(handles.text143,'Visible','on') %C2
end
        
        
        % Only allow those sliders which are relevant to MM movement be
        % shown if mesenchyme are able to be moved
    if handles.ck_movement_rule == 6 | handles.ck_movement_rule == 7 | handles.ck_movement_rule == 8
        set(handles.text99,'Visible','on')
        set(handles.text108,'Visible','on')
        set(handles.text109,'Visible','on')
        set(handles.text110,'Visible','on')
        set(handles.popupmenu15,'Visible','on')
        set(handles.popupmenu17,'Visible','on')
        set(handles.slider21,'Visible','on')
        set(handles.slider22,'Visible','on')
    else
        set(handles.text99,'Visible','off')
        set(handles.text108,'Visible','off')
        set(handles.text109,'Visible','off')
        set(handles.text110,'Visible','off')
        set(handles.popupmenu15,'Visible','off')
        set(handles.popupmenu17,'Visible','off')
        set(handles.slider21,'Visible','off')
        set(handles.slider22,'Visible','off')
    end
        
    if or(handles.ck_moveprob_rule==1, handles.ck_prolifprob_rule==1)
        set(handles.slider8,'Visible','on')
        set(handles.text45,'Visible','on')
        set(handles.text72,'Visible','on')
        set(handles.text47,'Visible','on')
    else
        set(handles.slider8,'Visible','off')
        set(handles.text45,'Visible','off')
        set(handles.text72,'Visible','off')
        set(handles.text47,'Visible','off')
    end


    if or(handles.ck_moveprob_rule~=1, handles.ck_prolifprob_rule~=1)
        set(handles.text60,'Visible','on')
        set(handles.text66,'Visible','on')
        set(handles.text61,'Visible','on')
        set(handles.text67,'Visible','on')
        set(handles.text68,'Visible','on')
        set(handles.slider16,'Visible','on')
        set(handles.slider19,'Visible','on')
    else
        set(handles.text60,'Visible','off')
        set(handles.text66,'Visible','off')
        set(handles.text61,'Visible','off')
        set(handles.text67,'Visible','off')
        set(handles.text68,'Visible','off')
        set(handles.slider16,'Visible','off')
        set(handles.slider19,'Visible','off')
    end
    
    % Hide last text box in LH panel if 1st or 7th rules are both chosen
    if or(and(handles.ck_moving_rule~=1,handles.ck_moving_rule~=7),and(handles.ck_prolif_choosecell_rule~=1,handles.ck_prolif_choosecell_rule~=7))
        set(handles.text69,'Visible','on')
        set(handles.text70,'Visible','on')
        set(handles.text71,'Visible','on')
        set(handles.slider20,'Visible','on')
    else
        set(handles.text69,'Visible','off')
        set(handles.text70,'Visible','off')
        set(handles.text71,'Visible','off')
        set(handles.slider20,'Visible','off')
    end
    
    if handles.ck_movement_rule == 6 || handles.ck_movement_rule == 7 || handles.ck_movement_rule == 8
        set(handles.popupmenu7,'Visible','on')
        set(handles.popupmenu9,'Visible','on')
        set(handles.popupmenu10,'Visible','off')
        set(handles.popupmenu11,'Visible','off')
        set(handles.popupmenu7,'Value',handles.ck_moving_rule)
        set(handles.popupmenu9,'Value',handles.ck_prolif_choosecell_rule)
        
        handles.mesenchyme_old = 1;
        % Update handles structure
        guidata(hObject, handles)
        
    elseif handles.mesenchyme_old == 1
        set(handles.popupmenu7,'Visible','off')
        set(handles.popupmenu9,'Visible','off')
        set(handles.popupmenu10,'Visible','on')
        set(handles.popupmenu11,'Visible','on')
        
        % Also need to reset the ck_moving_rules and
        % ck_prolif_choosecell_rule to 'allowed' options
        handles.ck_moving_rule = 1;
        handles.ck_prolif_choosecell_rule = 1;
        v_parameters(12) = handles.ck_moving_rule;
        v_parameters(15) = handles.ck_prolif_choosecell_rule;
        set(handles.popupmenu10,'Value',handles.ck_moving_rule);
        set(handles.popupmenu11,'Value',handles.ck_prolif_choosecell_rule);
        handles.mesenchyme_old = 0;
        % Update handles structure
        guidata(hObject, handles)
        
        
    else
        set(handles.popupmenu7,'Visible','off')
        set(handles.popupmenu9,'Visible','off')
        set(handles.popupmenu10,'Visible','on')
        set(handles.popupmenu11,'Visible','on')
    end
