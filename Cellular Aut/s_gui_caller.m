clear; close all; clc;

z = matlabpool('size');
if z <  8
    matlabpool open 8;
end

gui_CA2