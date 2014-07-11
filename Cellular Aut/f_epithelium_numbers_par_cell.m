function cell_epithelium_nums = f_epithelium_numbers_par_cell(cn_par,c_T,c_depth_m,c_width_m)
% A function which returns the numbers of epithelial cells at each time
% step up until c_T, across cn_par parallel simulations


z = matlabpool('size');
if z <  8
    matlabpool open 8;
end

cell_epithelium = cell(cn_par,1);
parfor i = 1:cn_par
    F = f_get_movie_invivo_cell_ret_initial(c_T,c_depth_m,c_width_m);
    a = F{1};
    cell_epithelium{i} = a;
end


cell_epithelium_nums = cell(cn_par,1);

for i = 1:cn_par
        cell_mcell = cell_epithelium{i};
        v_epithelium = zeros(c_T,1);
        
    for t = 1:c_T
        
        m_cell = cell_mcell{t};
        v_epithelium(t) = sum(sum(m_cell>=1)) - 4000;
    end
    cell_epithelium_nums{i} = v_epithelium;
    
end
