clear; close all; clc;

load('in_vivo_1.mat')

c_T = 80;
cn_iterations = 8;
c_miss = 2;
cn_observations = round(c_T/c_miss);

FigHandle = figure('Position', [100, 100, 1000, 500]);
vidObj = VideoWriter('in_vivo_new_3.avi');
vidObj.FrameRate = 2;
open(vidObj);


cell_details = cell_all_all{6};
m_cell_all = cell_details{1,1};
m_GDNF_all = cell_details{2,1};

for j = 1:cn_observations-5
    j
    m_cell = m_cell_all{j,1};
    m_GDNF = m_GDNF_all{j,1};

    cmap = [0 0 1; 1 1 1; 0 1 0];
    colormap(cmap);
    subplot(1,2,1),imagesc(flip(m_cell))
    title('Cell distribution','FontSize', 20)
    hold on
    % unique rectangles
    plot(rand(1, 10), 'g');
    plot(rand(1, 10), 'b');
    legend('Epithelium','Mesenchyme')
    hold off
    freezeColors

    subplot(1,2,2),imagesc(flip(m_GDNF))
    colormap('default')

    title('GDNF distribution','FontSize', 20)

    F(j) = getframe(FigHandle);
    writeVideo(vidObj,F(j));


    pause(0.1)
end



close(vidObj);