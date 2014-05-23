function [] = f_graph_plotter_void(m_cell,m_GDNF,v_epithelium,v_mesenchyme,v_acceptance,v_heterogeneity,v_perimeter,v_entropy,v_branch,v_mesenchyme_options,v_vacant_ratio,v_mesenchyme_ratio,t,graph_selector,handles)
% A function which plots the relevant images in response to the user selecting a plot
% choice from a dropdown menu

switch handles.graph_selector

    case 0 % Images
            axes(handles.axes1)
            imagesc(m_cell)
            

            axes(handles.axes2)
            imagesc(m_GDNF)
            hold on
            c=contour(m_GDNF);
            clabel(c)
            hold off
            
             % Graph selector
            set(handles.text7,'String','Cell distribution');
            set(handles.text9,'String','GDNF distribution');
            
            
            pause(0.01)
            
    case 1 % Cell numbers and perimeter
            
            axes(handles.axes1)
            plot(1:t,v_epithelium,'r','LineWidth',4)
            hold on
            plot(1:t,v_mesenchyme,'b','LineWidth',4)
%             legend('Epithelium','Mesenchyme')
            hold off
            xlim([1 handles.c_T])
            ylim([0 handles.c_width_full*handles.c_depth_full])
            
            
            
            axes(handles.axes2)
            plot(1:t,v_perimeter,'LineWidth',4)
            xlim([1 handles.c_T])
            ylim([0 1000])
            
            set(handles.text7,'String','Cell numbers');
            set(handles.text9,'String','Perimeter');
            
            
    case 2
            
            axes(handles.axes1)
            plot(1:t,v_acceptance,'LineWidth',4)
            xlim([1 handles.c_T])
            ylim([0 60])
            
            axes(handles.axes2)
            plot(1:t,v_heterogeneity,'LineWidth',4)
            xlim([1 handles.c_T])
            ylim([0 1])
            
            set(handles.text7,'String','Acceptance probability');
            set(handles.text9,'String','Target cell selection heterogeneity');
            
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
            
            
            
            axes(handles.axes2)
            plot(1:t,100*v_branch./v_epithelium,'LineWidth',4)
            xlim([1 handles.c_T])
            ylim([0 50])
            
            set(handles.text7,'String','Perimeter-to-area ratio');
            set(handles.text9,'String','Branch points per area');
            
            pause(0.01)
            
            
    case 4
            
            set(handles.text7,'String','Cell distribution');
            set(handles.text9,'String','Branch visualisation');
            
            
            axes(handles.axes1)
            imagesc(m_cell)
            
            m_cell = double(m_cell==1);

            skelImg   = bwmorph(m_cell, 'thin', 'inf');
            branchImg = bwmorph(skelImg, 'branchpoints');
            endImg    = bwmorph(skelImg, 'endpoints');

            [row, column] = find(endImg);
            endPts        = [row column];
            [row, column] = find(branchImg);
            branchPts     = [row column];
            

            axes(handles.axes2)

            imagesc(skelImg); 

            pause(0.01)
            
    case 5
            set(handles.text7,'String','Init mesenchyme');
            set(handles.text9,'String','New mesenchyme');
            
            
            axes(handles.axes1)
            imagesc(handles.m_mesenchyme_init)
            
            axes(handles.axes2)
            m_mesenchyme = double(m_cell==-1);
            imagesc(m_mesenchyme)
            pause(0.01)
            
    case 6
            set(handles.text7,'String','Average mesenchyme choice');
            set(handles.text9,'String','Ratio of vacant to mesenchyme selection ');
            
            axes(handles.axes1)
            plot(v_mesenchyme_options,'b','LineWidth',4)
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
            
    case 7
        
            
            
            pause(0.01)
            
        end
