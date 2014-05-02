function a=f_laplacian_test_null(m_lap,m_cell,c_tests, c_depth_full, c_width_full,c_dg)
%  A function which checks that the diagonals of the laplacian are what
%  they are supposed to be

% Select random indices to test against
v_depth_rand = round(0.5+c_depth_full*rand(c_tests,1));
v_width_rand = round(0.5+c_width_full*rand(c_tests,1));

for i = 1:c_tests
    %  Check non-epithelial cells first since their components shouldn't
    %  change
    if or(m_cell(v_depth_rand(i),v_width_rand(i)) == -1, m_cell(v_depth_rand(i),v_width_rand(i)) == 0)
        if v_depth_rand(i) > 1 && v_depth_rand(i) <  c_depth_full
            if m_lap(c_width_full*(v_depth_rand(i)-1) + v_width_rand(i),c_width_full*(v_depth_rand(i)-1) + v_width_rand(i))~= -4
                'error...laplacian value should equal -4, but it equals something else'
                a = 1;
                return;
            end
        else
            if m_lap(c_width_full*(v_depth_rand(i)-1) + v_width_rand(i),c_width_full*(v_depth_rand(i)-1) + v_width_rand(i))~= -3
                'error...laplacian value should equal -3, but it equals something else'
                a = 1;
                return;
            end
        end
    %  Check mesenchymal cells as their diagonal component of the Laplacian
    %  should change
    else
        if v_depth_rand(i) > 1 && v_depth_rand(i) <  c_depth_full
            if m_lap(c_width_full*(v_depth_rand(i)-1) + v_width_rand(i),c_width_full*(v_depth_rand(i)-1) + v_width_rand(i))~= (-4-(1/c_dg))
                'error...laplacian value should equal -4 minus delta, but it equals something else'
                a = 1;
                return;
            end
        else
            if m_lap(c_width_full*(v_depth_rand(i)-1) + v_width_rand(i),c_width_full*(v_depth_rand(i)-1) + v_width_rand(i))~= (-3 - (1/c_dg))
                'error...laplacian value should equal -3 minus delta, but it equals something else'
                a = 1;
                return;
            end
        end
    end
end

a = 0;