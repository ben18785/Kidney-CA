function [] = f_invitro_void(c_T,c_size,ck_dg,ck_gamma,ck_neighbours,ck_movement_rule,ck_moveprob_rule,ck_moving_rule)
% A function which allows user to input parameters and plots the result


%% Parameters
% Specify the number of time cycles to iterate through
% c_T = 100;

% Specify the parameters for the area
% c_size = 200; 
c_width_full = c_size;
c_depth_full = c_size;
c_width_e = c_width_full;
c_width_m = c_width_full;
c_depth_e = 1;
c_separation = 0;
c_depth_m = c_size;
c_epithelium_density = 1; 
c_mesenchyme_density = 0.1;
c_depth_mesenstart = 1;
c_width_mesenstart = 1;

handles.v_parameters = [handles.ck_dg;handles.ck_gamma; handles.ckp_moveprob; handles.ck_neighbours;handles.ck_movement_rule;handles.c_depth_full;handles.c_width_full;handles.ck_moveprob_rule;handles.ck_moveprob_cons;handles.ck_move_norm_cons;handles.ck_move_norm_slope;handles.ck_moving_rule;handles.c_pmove_grad;handles.ck_prolifprob_rule;handles.ck_prolif_choosecell_rule;handles.c_beta_mesmove;handles.c_mes_movement];


%% Initial area of epithelium and mesenchyme created, and the initial field of GDNF calculated
% Create the epithelium layer, and the mesenchyme
m_cell = f_create_area_m(c_width_full, c_depth_full);
m_cell = f_create_random_epithelium_m(m_cell, c_depth_full/2,c_width_full/2, 500,v_parameters);
m_cell = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density, c_depth_mesenstart,c_width_mesenstart);


% Create the initial field of GDNF according to the distribution of the
% mesenchyme and epithelium
m_GDNF = f_field_update_m(m_cell,v_parameters);


%% Run the simulation through the T time steps
% Iterate through updating the m_cell and m_GDNF arrays at each time step
c_mesen_tot = sum(sum(m_cell==-1));


% Go through the time steps 
for t = 1:c_T
    t
    c_mesen_running = sum(sum(m_cell==-1));
    if c_mesen_running ~=c_mesen_tot
        'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
    end
        
    m_cell = f_update_cells_m(m_cell,m_GDNF,v_parameters);
    m_GDNF = f_field_update_m(m_cell,v_parameters);
    imagesc(m_cell)
    axes(handles.axes1)
    title('Cell distribution')
%     imagesc(m_GDNF)
%     title('GDNF distribution')
    pause(0.01)
end