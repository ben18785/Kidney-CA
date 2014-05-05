function c_test = f_test_cellconnected_c()
% A function which tests the working of cellconnected by generating all
% possible combinations of unconnected and connected cells, then testing
% whether they are connected or unconnected. It returns 0 if the test is
% working ok, and 1 if not

c_depth_full = 100;
c_width_full = 1000;

% Need this vector to use the f_cellconnected_c function
v_parameters = zeros(7,1);
v_parameters(6) = c_depth_full;
v_parameters(7) = c_width_full;

% Create a 1st test area
m_cell_1 = f_create_area_m(c_width_full, c_depth_full);

% Create all non-boundary unconnected components
m_test_activecells_nb = [50,50;50,53;50,56;50,59;50,63;50,66;50,70;50,74;50,77;50,80;50,84;51,88];
m_testindices_unconnectednb = cell(12,1);

m_testindices_unconnectednb{1} = [49,49;49,51;51,49;51,51];
m_testindices_unconnectednb{2} = [1,1];
m_testindices_unconnectednb{3} = [49,57;51,55;51,57];
m_testindices_unconnectednb{4} = [49,60;51,60];
m_testindices_unconnectednb{5} = [49,62;51,64];
m_testindices_unconnectednb{6} = [51,65;51,67];
m_testindices_unconnectednb{7} = [49,71;51,69];
m_testindices_unconnectednb{8} = [49,73;51,73];
m_testindices_unconnectednb{9} = [49,78];
m_testindices_unconnectednb{10} = [51,81];
m_testindices_unconnectednb{11} = [51,83];
m_testindices_unconnectednb{12} = [50,87];


cn_tests_unconnected = length(m_test_activecells_nb);
c_test = 0;

% Put the non-boundary unconnected components into the matrix of simulation
for i = 1:cn_tests_unconnected
    m_coords = m_testindices_unconnectednb{i};
    c_coordlen = size(m_coords);
    c_coordlen = c_coordlen(1);
    for j = 1:c_coordlen
        m_cell_1(m_coords(j,1),m_coords(j,2)) = 1;
    end
    m_cell_1(m_test_activecells_nb(i,1),m_test_activecells_nb(i,2)) = 1;
end

for i = 1:cn_tests_unconnected
    c_test = c_test + f_cellconnected_c(m_test_activecells_nb(i,1),m_test_activecells_nb(i,2),m_cell_1,v_parameters);
end

m_tests_xboundary1 = [1,50;1,53;1,56;1,1; 50,1];
m_testindices_xboundary1 = [50,50;2,54;2,55;50,55;51,1000];
cn_tests_xboundary1 = length(m_tests_xboundary1);
m_cell_2 = f_create_area_m(c_width_full, c_depth_full);

for i = 1:cn_tests_xboundary1
    m_coords = m_testindices_xboundary1(i,:);
    c_coordlen = size(m_coords);
    c_coordlen = c_coordlen(1);
    for j = 1:c_coordlen
        m_cell_2(m_coords(j,1),m_coords(j,2)) = 1;
    end
    m_cell_2(m_tests_xboundary1(i,1),m_tests_xboundary1(i,2)) = 1;    
end

for i = 1:cn_tests_xboundary1
    c_test = c_test + f_cellconnected_c(m_tests_xboundary1(i,1),m_tests_xboundary1(i,2),m_cell_2,v_parameters);
end
