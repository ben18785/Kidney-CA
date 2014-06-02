clear all; close all; clc;

tic

if matlabpool('size') < 4
    matlabpool(4)
end

c_T = 80;
cn_iterations = 8;
c_miss = 2;
cn_observations = round(c_T/c_miss);

% Hold the cell arrays from each of the loops as separate components of a
% larger cell array
cell_all_all = cell(cn_iterations,1);

parfor i = 1:cn_iterations
    cell_all = f_get_cellandgdnf_cell(c_T,c_miss);
    cell_all_all{i} = cell_all;
end

for i = 1:cn_iterations
    cell_details = cell_all_all{i};
    m_cell_all = cell_details{1,1};
    m_GDNF_all = cell_details{2,1};
        
    for j = 1:cn_observations
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
        
        pause(0.1)
    end
end

toc

