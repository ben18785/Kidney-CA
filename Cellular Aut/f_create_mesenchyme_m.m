function [m_cell] = f_create_mesenchyme_m(m_cell, c_width_m, c_depth_m, c_mesenchyme_density,c_depth_mesenstart,c_width_mesenstart)
% A function which creates the mesenchyme cells (in the appropriate layer)
% in accordance with its density (<< than epithelium)

% Get the full dimensions
v_dimensions_full = size(m_cell);
c_width_full = v_dimensions_full(2);
c_depth_full = v_dimensions_full(1);

% A quick check of dimensions
if or(c_width_m > c_width_full,c_depth_m > c_depth_full)
    'An error has occurred: please enter a width or depth for the mesenchyme which is less than the full dimensions' %#ok<NOPRT>
    return;
end

% Calculate the number of cells in the epithelium which will be created
c_num_m = round(c_width_m*c_depth_m*c_mesenchyme_density);

% Get the indices of all the cells which are in the initial area where the
% epithelium cells are found. These correspond to the cells which are
% within 1:c_depth_e (of the WD), or within 1:c_width_e of the LH boundary.
% This is a rectangular area.
m_mesenchyme_indices = zeros(c_width_m*c_depth_m,2);

k = 1;
for i = c_depth_mesenstart:c_depth_full
    for j = c_width_mesenstart:(c_width_mesenstart+c_width_m)
        m_mesenchyme_indices(k,:) = [i,j];
        k = k + 1;
    end
end

% Now to get a random list of the indices
m_mesenchyme_indices = f_random_indices(m_mesenchyme_indices);


% Now place epithelium cells in the first c_num_e random locations
for i = 1:c_num_m
    m_cell(m_mesenchyme_indices(i,1),m_mesenchyme_indices(i,2)) = -1;
end