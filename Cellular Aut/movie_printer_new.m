clear; close all; clc;

load('invitro_1.mat')

FigHandle = figure('Position', [100, 100, 500, 500]);
vidObj = VideoWriter('invitro_new.avi');
vidObj.FrameRate = 1;
open(vidObj);


c_T = 25;
% Extract the cell and GDNF components respectively
a = A{1};

pause(1)

for i = 1:c_T
    m_cell = a{i};
    
    cmap = [0 0 1; 1 1 1; 1 1 0; 1 0 0];
    colormap(cmap);
    imagesc(m_cell)
    title('Cell distribution','FontSize', 20)
    pause(0.01)
    
    F(i) = getframe(FigHandle);
    writeVideo(vidObj,F(i));
end




close(vidObj);