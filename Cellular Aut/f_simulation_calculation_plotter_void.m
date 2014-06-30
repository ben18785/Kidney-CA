function [] = f_simulation_calculation_plotter_void(m_cell,m_GDNF,c_mesen_tot,hObject,handles)
% A function which carries out the calculations in each of the simulation
% and then draws the graphs

% Go through the time steps 
for t = 1:handles.c_T
    set(handles.text11,'String',num2str(t));
    % Update handles structure globally each iteration
    handles = guidata(hObject);
    f_diagnostic_guivis_void(handles);
    
    % Try to break the loop if a new command is chosen
    if handles.stop1 == 1
        break;
    end
    
    if handles.test1 == 0
        c_mesen_running = sum(sum(m_cell==-1));
        if c_mesen_running ~=c_mesen_tot
            'A mesenchyme has gone missing (f_lifecyle_iterator_ms)'
        end

        
        
        [m_cell,c_move,c_heterogeneity,c_mesenchyme_options,c_vacant_select,c_mesenchyme_select,c_cell_options] = f_update_cells_m(m_cell,m_GDNF,handles.v_parameters);
        v_heterogeneity(t) = c_heterogeneity;
        
        % Average number of vacant spots available for the mesenchyme cells
        % to move into
        v_mesenchyme_options(t) = c_mesenchyme_options/c_mesenchyme_select;
        
        % Calculate the ratio of total cells chosen which are mesenchyme vs
        % vacant
        v_vacant_ratio(t) = 100*c_vacant_select/(c_mesenchyme_select+c_vacant_select);
        v_mesenchyme_ratio(t) = 100*c_mesenchyme_select/(c_mesenchyme_select+c_vacant_select);
        
        m_GDNF = f_field_update_m(m_cell,handles.v_parameters);
        
        % Get the total number of epithelium cells
        c_epithelium = sum(sum(m_cell>=1));
        
        % Get the total number of Ret-H and Ret-L cells
        c_epithelium_RH = sum(sum(m_cell==2));
        c_epithelium_RL = sum(sum(m_cell==1));
        v_epithelium_RH(t) = c_epithelium_RH;
        v_epithelium_RL(t) = c_epithelium_RL;
        
        % Now put it as a % of size of total region
        c_total = handles.c_depth_full*handles.c_width_full;
        c_epithelium_per = c_epithelium;
        v_epithelium(t) = c_epithelium_per;
        
        % Count the number of mesenchyme
        v_mesenchyme(t) = c_mesen_running;
        
        % Work out the acceptance rate
        c_acceptance = 100*c_move/c_epithelium;
        v_acceptance(t) = c_acceptance;
        
        % Work out the perimeter
        [c_perimeter_approx,c_area_approx,c_area_true] = f_perimeterarea_branching_c(m_cell);
        v_perimeter(t) = c_perimeter_approx;
        
        % Work out epithelium entropy
        % First of all make all the components of the image which are not 1 zero
        c_cell_entropy = entropy(m_cell.*(m_cell==1));
        v_entropy(t) = c_cell_entropy;
        
        % Now work out the number of branchpoints
        skelImg   = bwmorph(m_cell, 'thin', 'inf');
        branchImg = bwmorph(skelImg, 'branchpoints');
        
        [row, column] = find(branchImg);
        branchPts     = [row column];
        
        cn_branch = length(branchPts);
        
        v_branch(t) = cn_branch;
        
       
        % Estimate the perimeter via edge detection
        c_perimeter_approx_new = f_perimeter_edge_approx_c(m_cell,20);
        v_perimeter_new(t) = c_perimeter_approx_new;
        
        % Get a measure of the variance in GDNF along the perimeter
        m_perimeter_GDNF = f_perimeter_GDNF_m(m_cell,m_GDNF,handles.v_parameters);
        v_perimeter_GDNF(t) = std(m_perimeter_GDNF(:,3));
        v_perimeter_GDNF_average(t) = mean(m_perimeter_GDNF(:,3));
        
        
         % Call a fn which plots the correct graph based on
        % handles.graph_selector
        f_graph_plotter_void(m_cell,m_GDNF,v_epithelium,v_mesenchyme,v_acceptance,v_heterogeneity,v_perimeter,v_perimeter_new,v_entropy,v_branch,v_mesenchyme_options,v_vacant_ratio,v_mesenchyme_ratio,v_perimeter_GDNF,v_perimeter_GDNF_average,v_epithelium_RH,v_epithelium_RL,t,handles.graph_selector,handles)
        
        
        
    else
            while handles.test1 == 1
                    % Update handles structure globally each iteration
                handles = guidata(hObject);
                pause(0.01)
            end
    end
    
    
end
