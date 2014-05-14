function [c_perimeter_approx,c_area_approx,c_area_true] = f_perimeterarea_branching_c(m_cell)
% A function which estimates the perimeter and area of the epithelial mass.
% It returns both the approximate and true areas so that they can be
% compared. There are no other simple ways to get the perimeter so only one
% value is returned here.

% Calculate the number of epithelium cells
cn_nonzero = sum(sum(m_cell==1));

% First of all make all the components of the image which are not 1 zero
m_cell = m_cell.*(m_cell==1);


% Find the connected components of the image
cell_mcell_connected = bwconncomp(m_cell, 8);

% Get the number of objects in the cell array
cn_objects = cell_mcell_connected.NumObjects;

% Get the area property and perimeter properties and store these
cell_area = regionprops(cell_mcell_connected,'Area');
cell_perimeter = regionprops(cell_mcell_connected,'Perimeter');

% Take the one with the largest area
c_area = 0;
c_largest_index = 0;

for i = 1:cn_objects
    if cell_area(i).Area > c_area
        c_largest_index = i;
        c_area = cell_area(i).Area;
    end
end

% % Needed for plotting
% grain = false(size(m_cell));
% grain(cell_mcell_connected.PixelIdxList{c_largest_index}) = true;
% subplot(1,2,1),imagesc(m_cell)
% subplot(1,2,2),imagesc(grain)

c_area_true = sum(sum(m_cell==1));
c_area_approx = cell_area(c_largest_index).Area;
c_perimeter_approx = cell_perimeter(c_largest_index).Perimeter;