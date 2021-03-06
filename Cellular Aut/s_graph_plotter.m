clear; close all; clc;

load('bifurcations.mat')
c_T = 65;
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

pause(1)
figure(1)
m_cell = a{10};
cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
colormap(cmap);
imagesc(m_cell)
title('Cell distribution','FontSize', 20)
figure(2)
m_cell = a{25};
cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
colormap(cmap);
imagesc(m_cell)
title('Cell distribution','FontSize', 20)
figure(3)
m_cell = a{40};
cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
colormap(cmap);
imagesc(m_cell)
title('Cell distribution','FontSize', 20)
figure(4)
m_cell = a{55};
cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
colormap(cmap);
imagesc(m_cell)
title('Cell distribution','FontSize', 20)