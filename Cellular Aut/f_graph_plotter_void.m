function [] = f_graph_plotter_void(m_cell,m_GDNF,v_epithelium,v_mesenchyme,v_acceptance,v_heterogeneity,v_perimeter,v_perimeter_new,v_entropy,v_branch,v_mesenchyme_options,v_vacant_ratio,v_mesenchyme_ratio,v_perimeter_GDNF,v_perimeter_GDNF_average,v_epithelium_RH,v_epithelium_RL,t,graph_selector,handles)
% A function which plots the relevant images in response to the user selecting a plot
% choice from a dropdown menu

if handles.graph_selector == 8
    set(handles.text122,'Visible','on')
    set(handles.text123,'Visible','on')
else
    set(handles.text122,'Visible','off')
    set(handles.text123,'Visible','off')
end
    
if handles.graph_selector == 7
    set(handles.text124,'Visible','on')
    set(handles.text125,'Visible','on')
else
    set(handles.text124,'Visible','off')
    set(handles.text125,'Visible','off')
end

if handles.graph_selector == 6
    set(handles.text126,'Visible','on')
    set(handles.text127,'Visible','on')
    set(handles.text128,'Visible','on')
else
    set(handles.text126,'Visible','off')
    set(handles.text127,'Visible','off')
    set(handles.text128,'Visible','off')
end


switch handles.graph_selector

    case 0 % Images
            axes(handles.axes1)
            cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
            colormap(cmap);
            imagesc(flip(m_cell))
            freezeColors

            colormap('default')
            axes(handles.axes2)
            imagesc(flip(m_GDNF))
            hold on
            c=contour(flip(m_GDNF));
            clabel(c)
            hold off
            
             % Graph selector
            set(handles.text7,'String','Cell distribution');
            set(handles.text9,'String','GDNF distribution');
            
            
            pause(0.01)
            
    case 1 % Cell numbers and perimeter
        
            if handles.ck_ret_on == 0 % Ret not being considered  
            
                axes(handles.axes1)
                plot(1:t,v_epithelium,'r','LineWidth',4)
                hold on
                plot(1:t,v_mesenchyme,'b','LineWidth',4)
    %             legend('Epithelium','Mesenchyme')
                hold off
                xlim([1 handles.c_T])
                ylim([0 handles.c_width_full*handles.c_depth_full])
                xlabel('Simulation time')
                ylabel('Cell numbers')



                axes(handles.axes2)
                plot(1:t,v_perimeter,'LineWidth',4)
                xlim([1 handles.c_T])
                ylim([0 1000])
                xlabel('Simulation time')
                ylabel('Perimeter estimate')

                set(handles.text7,'String','Cell numbers');
                set(handles.text9,'String','Perimeter');
                
            else
                axes(handles.axes1)
                plot(1:t,v_epithelium_RH,'r','LineWidth',4)
                hold on
                plot(1:t,v_epithelium_RL,'m','LineWidth',4)
                hold on
                plot(1:t,v_mesenchyme,'b','LineWidth',4)
   
                hold off
                xlim([1 handles.c_T])
                ylim([0 handles.c_width_full*handles.c_depth_full])
                xlabel('Simulation time')
                ylabel('Cell numbers')



                axes(handles.axes2)
                plot(1:t,v_perimeter,'LineWidth',4)
                xlim([1 handles.c_T])
                ylim([0 1000])
                xlabel('Simulation time')
                ylabel('Perimeter estimate')

                set(handles.text7,'String','Cell numbers');
                set(handles.text9,'String','Perimeter');
            end
            
            
    case 2
            
            axes(handles.axes1)
            plot(1:t,v_acceptance,'LineWidth',4)
            xlim([1 handles.c_T])
            ylim([0 60])
            xlabel('Simulation time')
            ylabel('Acceptance rate')
            
            axes(handles.axes2)
            plot(1:t,v_heterogeneity,'LineWidth',4)
            xlim([1 handles.c_T])
            ylim([0 1])
            xlabel('Simulation time')
            ylabel('Heterogeneity in cell target cell selection')
            
            set(handles.text7,'String','Acceptance probability');
            set(handles.text9,'String','Target cell selection heterogeneity for epithelium');
            
            pause(0.01)           
            
    case 3
            
            % Work out the radius of a circle that would give that area
            v_radius = sqrt(v_epithelium/pi);
            
            % Work out the perimeter to area ratio for a circle (should be
            % smallest possible
            v_perarea_circle = 2./v_radius;
            
            % Now plot both
            
            axes(handles.axes1)
            plot(1:t,v_perimeter./v_epithelium,'r','LineWidth',4)
            hold on
            plot(1:t,v_perarea_circle,'b','LineWidth',4)
            hold off
            xlim([1 handles.c_T])
            ylim([0 1])
            xlabel('Simulation time')
            ylabel('Perimeter-to-area ratio')
            
            
            
            axes(handles.axes2)
            plot(1:t,100*v_branch./v_epithelium,'LineWidth',4)
            xlim([1 handles.c_T])
            ylim([0 50])
            xlabel('Simulation time')
            ylabel('Number of branch points per unit area')
            
            set(handles.text7,'String','Perimeter-to-area ratio');
            set(handles.text9,'String','Branch points per area');
            
            pause(0.01)
            
            
    case 4
            
            set(handles.text7,'String','Cell distribution');
            set(handles.text9,'String','Branch visualisation');
            
            
            axes(handles.axes1)
            cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
            colormap(cmap);
            imagesc(flip(m_cell))
            freezeColors
            
            colormap('default')
            m_cell = double(m_cell>=1);

            skelImg   = bwmorph(m_cell, 'thin', 'inf');
            branchImg = bwmorph(skelImg, 'branchpoints');
            endImg    = bwmorph(skelImg, 'endpoints');

            [row, column] = find(endImg);
            endPts        = [row column];
            [row, column] = find(branchImg);
            branchPts     = [row column];
            

            axes(handles.axes2)

            imagesc(flip(skelImg)); 

            pause(0.01)
            
    case 5
            set(handles.text7,'String','Initial mesenchyme');
            set(handles.text9,'String','Current mesenchyme');
            
            cmap = [1 1 1; 0 0 1];
            colormap(cmap);
            axes(handles.axes1)
            imagesc(flip(handles.m_mesenchyme_init))
            
            axes(handles.axes2)
            m_mesenchyme = double(m_cell==-1);
            imagesc(flip(m_mesenchyme))
            pause(0.01)
            
    case 6
            set(handles.text7,'String','Average mesenchyme choice');
            set(handles.text9,'String','Ratio of vacant to mesenchyme selection ');
            
            axes(handles.axes1)
            plot(v_mesenchyme_options,'b','LineWidth',4)
            xlabel('Simulation time')
            ylabel('Average number of cells considered for mesenchyme')
            xlim([1 handles.c_T])
            ylim([0 60])
            
            axes(handles.axes2)
            plot(v_mesenchyme_ratio,'b','LineWidth',4)
            hold on
            plot(v_vacant_ratio,'r','LineWidth',4)
            hold on
            plot(v_vacant_ratio+v_mesenchyme_ratio,'g','LineWidth',4)
            hold off
            xlim([1 handles.c_T])
            ylim([0 100])
            xlabel('Simulation time')
            ylabel('Ratio of vacant and mesenchyme cells considered by epithelium')
            pause(0.01)
            
    case 7
            v_parameters = handles.v_parameters;
            set(handles.text7,'String','Cell distribution with perimeter');
            set(handles.text9,'String','Comparison of perimeter estimation methods');
            cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
            colormap(cmap);
            axes(handles.axes1)
            imagesc(flip(m_cell))
            hold on
            
            c_depth_full = v_parameters(7);
            m_perimeter_approx = f_perimeter_edge_approx_m(m_cell,v_parameters,20);
            v_perimeter_height = c_depth_full - m_perimeter_approx(:,1)
            scatter(m_perimeter_approx(:,2), v_perimeter_height,'m.')
            hold off
            
            
            axes(handles.axes2)
            plot(v_perimeter,'b','LineWidth',4)
            hold on
            plot(v_perimeter_new,'r','LineWidth',4)
            hold off
            xlim([1 handles.c_T])
            ylim([0 1000])
            xlabel('Simulation time')
            ylabel('Perimeter estimate')
            
            
            pause(0.01)
            
    case 8
        
            v_parameters = handles.v_parameters;
            set(handles.text7,'String','Perimeter GDNF distribution');
            set(handles.text9,'String','Perimeter GDNF statistics');
            
            m_perimeter_GDNF = f_perimeter_GDNF_m(m_cell,m_GDNF,v_parameters);
            cn_numper = length_new(m_perimeter_GDNF);
            axes(handles.axes1)
            scatter3(m_perimeter_GDNF(:,1),m_perimeter_GDNF(:,2),m_perimeter_GDNF(:,3),100*ones(cn_numper,1),m_perimeter_GDNF(:,3),'Filled')
            zlim([0 5])
            zlabel('GDNF concentration')
            
            axes(handles.axes2)
            plot(v_perimeter_GDNF,'b','LineWidth',4)
            hold on
            plot(v_perimeter_GDNF_average,'r','LineWidth',4)
            hold off
            xlim([1 handles.c_T])
            ylim([0 10])
            xlabel('Simulation time')
            ylabel('GDNF concentration')
            
            
            pause(0.01)
            
        end
