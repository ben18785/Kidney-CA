function [m_cell] = f_create_epithelium_ret_m(m_cell, c_width_e, c_depth_e, c_epithelium_density,v_parameters)
% A function which creates the epithelium (cells taking on the value 1 if Ret low, 2 if Ret high)
% within the simulation domain according to the cell density (placing the
% cells randomly within the domain of the epithelial layer

% Get the full dimensions
v_dimensions_full = size(m_cell);
c_width_full = v_dimensions_full(2);
c_depth_full = v_dimensions_full(1);

% A quick check of dimensions
if or(c_width_e > c_width_full,c_depth_e > c_depth_full)
    'An error has occurred: please enter a width or depth for the epithelium which is less than the full dimensions' %#ok<NOPRT>
    return;
end

% Calculate the number of cells in the epithelium which will be created
c_num_e = round(c_width_e*c_depth_e*c_epithelium_density);

% Get the indices of all the cells which are in the initial area where the
% epithelium cells are found. These correspond to the cells which are
% within 1:c_depth_e (of the WD), or within 1:c_width_e of the LH boundary.
% This is a rectangular area.
m_epithelium_indices = zeros(c_width_e*c_depth_e,2);

for i = 1:c_depth_e
    for j = 1:c_width_e
        m_epithelium_indices((i-1)*c_width_e + j,:) = [i,j];
    end
end

% Now to get a random list of the indices
m_epithelium_indices = f_random_indices(m_epithelium_indices);

% Calculate a proportion of the cells which are Ret-high vs Ret-low
ck_rh_num = v_parameters(41);
c_num_h = c_num_e*ck_rh_num;
c_num_l = c_num_e - c_num_h;

% Now place epithelium cells in the first c_num_e random locations
k = 1;
for i = 1:c_num_h
    m_cell(m_epithelium_indices(k,1),m_epithelium_indices(k,2)) = 2;
    k = k + 1;
end
for i = 1:c_num_l
    m_cell(m_epithelium_indices(k,1),m_epithelium_indices(k,2)) = 1;
    k = k + 1;
end




        


