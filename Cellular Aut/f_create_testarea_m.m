function m_cell = f_create_testarea_m(c_width_full,c_depth_full,c_depth_e,c_width_e,c_depth_testmesstart,c_depthlen_testmes,c_width_testmesstart,c_widthlen_test);
% A function which creates a test area with a fully thick epithelium layer,
% and a block on mesenchyme cells a way away

m_cell = f_create_area_m(c_width_full, c_depth_full);

for i = 1:c_depth_e
    for j = 1:c_width_e
        m_cell(i,j) = 1;
    end
end

for i = c_depth_testmesstart:(c_depth_testmesstart+c_depthlen_testmes)
    for j = c_width_testmesstart:(c_width_testmesstart+c_widthlen_test-1)
        m_cell(i,j) = -1;
    end
end

    