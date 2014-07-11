clear; close all; clc;


v_depth = [5; 10; 20; 40; 80];
v_width = [5; 10; 20; 40; 80];

% First make a list of all the possible parameter combinations
cn_len_dep = length(v_depth);
cn_len_wid = length(v_width);

v_parameters = zeros(cn_len_dep*cn_len_wid,2);

k = 1;
for i = 1:cn_len_dep
    for j = 1:cn_len_wid
        v_parameters(k,:) = [v_depth(i), v_width(j)];
        k = k + 1;
    end
end

cn_parameters = length(v_parameters);

c_T = 35;
cn_par = 8;

cell_parameters = cell(cn_parameters,1);
for i = 1:cn_parameters
    i
    cell_epithelium_nums = f_epithelium_numbers_par_cell(cn_par,c_T,v_parameters(i,1),v_parameters(i,2));
    cell_parameters{i} = cell_epithelium_nums;
end
