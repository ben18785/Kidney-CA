clear; close all; clc;
c_T = 65;

A = f_get_movie_invivo_cell_ret(c_T);

% Extract the cell and GDNF components respectively
a = A{1};

pause(1)
FigHandle = figure('Position', [100, 100, 500, 500]);
for i = 1:c_T
    m_cell = a{i};
    
    cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
    colormap(cmap);
    imagesc(m_cell)
    title('Cell distribution','FontSize', 20)
    pause(0.01)
end