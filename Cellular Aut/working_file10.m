clear; close all; clc;

v_parameters = zeros(21,1);
v_parameters(5) = 8;
v_parameters(6) = 200;
v_parameters(7) = 200;

% Get the dimensions of the search space to be considered
v_parameters(20) = 2;
v_parameters(21) = 2;

c_xold = 2;
c_xnew = 3;
c_yold = 200;
c_ynew = 1;


m_cell = zeros(200,200);
m_cell(c_xnew,c_ynew) = -1;



[c_allowed,m_mesenchyme] = f_allindices_allnearby_m(c_xold,c_yold,c_xnew,c_ynew,m_cell,v_parameters)