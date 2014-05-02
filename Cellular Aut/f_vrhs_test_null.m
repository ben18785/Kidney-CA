function b = f_vrhs_test_null(v_rhs,m_cell,c_tests,c_depth_full,c_width_full,c_dg,c_gamma)
% A function which checks that the correct modifications have been made to
% the v_rhs vector

% Select random indices to test against
v_depth_rand = round(0.5+c_depth_full*rand(c_tests,1));
v_width_rand = round(0.5+c_width_full*rand(c_tests,1));

% Now go through all of the tests
for i = 1:c_tests
    if m_cell(v_depth_rand(i),v_width_rand(i)) == -1
        if v_rhs((v_depth_rand(i)-1)*c_width_full+v_width_rand(i)) ~= -c_gamma/c_dg
            'Error...something is wrong the v_rhs'
            b = 1;
            return;
        end
    end
end

b = 0;

    