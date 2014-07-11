clear; close all; clc;

cn_par = 8;
c_T = 25;
c_depth_m = 20;
c_width_m = 40;

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
        cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
        colormap(cmap);
        imagesc(m_cell)
        title('Cell distribution','FontSize', 20)
        pause(0.1)
    end
    cell_epithelium_nums{i} = v_epithelium;
    pause(1)
end

for i = 1:cn_par
    v_epithelium = cell_epithelium_nums{i};
    plot(v_epithelium)
    hold on
end