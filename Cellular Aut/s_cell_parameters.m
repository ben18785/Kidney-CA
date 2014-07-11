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
    

load('cell_parameters.mat')

v_cell_numbers = v_parameters(:,1).*v_parameters(:,2);

m_av_epithelium = zeros(25,35);
m_sd_epithelium = zeros(25,35);

for i = 1:25
    a = cell_parameters{i};
    b = [];
    for j = 1:8
        b = [b; (a{j})'];
    end
    m_av_epithelium(i,:) = mean(b);
    m_sd_epithelium(i,:) = std(b);
end

v_av_epithelium = m_av_epithelium(:,35);
v_sd_epithelium = m_sd_epithelium(:,35);
v_upper_epithelium = v_av_epithelium + v_sd_epithelium;
v_lower_epithelium = v_av_epithelium - v_sd_epithelium;

m_heat_av = zeros(5,5);
for i = 1:5
    for j = 1:5
        m_heat_av(i,j) = v_av_epithelium((i-1)*5 + j);
    end
end

% Now making the matrix of the initial numbers of mesenchyme in the depth
% and width
m_heat_mes = zeros(5,5);
for i = 1:5
    for j = 1:5
        m_heat_mes(i,j) = v_cell_numbers((i-1)*5 + j);
    end
end



hmap = HeatMap(m_heat_av,'RowLabels',v_depth,'ColumnLabels',v_width,'Colormap', 'redbluecmap')
addYLabel(hmap,'Width')
addXLabel(hmap,'Depth')

v_total = [v_parameters v_cell_numbers v_av_epithelium v_av_epithelium./v_cell_numbers];

p = polyfit(v_cell_numbers,v_av_epithelium,2);   % p returns 2 coefficients fitting r = a_1 * x + a_2
x = linspace(0,7000,50);
r_av = p(1) .* x.^2 + p(2).*x + p(3); % compute a new vector r that has matching datapoints in x
p = polyfit(v_cell_numbers,v_upper_epithelium,2);   % p returns 2 coefficients fitting r = a_1 * x + a_2
x = linspace(0,7000,50);
r_up = p(1) .* x.^2 + p(2).*x + p(3); % compute a new vector r that has matching datapoints in x
p = polyfit(v_cell_numbers,v_lower_epithelium,2);   % p returns 2 coefficients fitting r = a_1 * x + a_2
x = linspace(0,7000,50);
r_low = p(1) .* x.^2 + p(2).*x + p(3); % compute a new vector r that has matching datapoints in x


figure(2)
scatter(v_cell_numbers,v_av_epithelium,60,'b','hexagram','fill')
hold on
plot(x, r_av,'r','LineWidth',3)
hold on
plot(x, r_up,'g--','LineWidth',3)
hold on
plot(x, r_low,'g--','LineWidth',3)
ylim([0 7000])
xlim([0 6500])
xlabel('Initial Mesenchyme numbers')
ylabel('Final Epithelium numbers')
legend('data','fitted curve','error bounds')



figure(3)
v_cell_increment = v_av_epithelium./v_cell_numbers;
v_cell_increment_upper = v_upper_epithelium./v_cell_numbers;
v_cell_increment_lower = v_lower_epithelium./v_cell_numbers;
f_av = fit(v_cell_numbers/4000, v_cell_increment, 'smoothingspline')
f_up = fit(v_cell_numbers/4000, v_cell_increment_upper, 'smoothingspline')
f_low = fit(v_cell_numbers/4000, v_cell_increment_lower, 'smoothingspline')
h1 = plot(f_av,v_cell_numbers/4000,v_cell_increment)
hold on
h2 = plot(f_up,'g--')
hold on
h3 = plot(f_low,'g--')
xlabel('Initial Mesenchyme to Epithelium ratio')
ylabel('Final Epithelium to Mesenchyme ratio')
xlim([0 1.6])
set(h1,'MarkerSize',15,'LineWidth',3)
set(h2,'MarkerSize',15,'LineWidth',3)
set(h3,'MarkerSize',15,'LineWidth',3)
legend('data','fitted curve','error bounds')
% Now look into the differential effect of changing the width vs depth
b = fitlm(v_parameters,v_cell_increment,'linear');
v_parameters = [v_parameters zeros(25,2)];

for i = 1:25
    v_parameters(i,3) = v_parameters(i,1)^2;
    v_parameters(i,4) = v_parameters(i,2)^2;
end

c = fitlm(v_parameters,v_cell_increment,'linear');

v_testreg = [v_parameters(:,1) v_parameters(:,1)+v_parameters(:,2) v_parameters(:,3) v_parameters(:,4)];
d = fitlm(v_testreg,v_av_epithelium,'linear') 