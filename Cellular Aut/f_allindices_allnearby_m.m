function [c_allowed,m_mesenchyme] = f_allindices_allnearby_m(c_xold,c_yold,c_xnew,c_ynew,m_cell,v_parameters)
% A function which considers a epithelium moving from (c_xold,c_yold) to the
% place of a mesenchyme at (c_xnew,c_ynew). The function does a sweep of
% all the cells in the vicinity of the mesenchyme spot.

% Do a test to check that this is being run under the right conditions
ck_movement_rule = v_parameters(5);
if ck_movement_rule ~= 8
    'An error has been made, resulting in f_allindices_allnearby_m being run under a ck_movement_rule other than 8'
end

% Test whether the cell which is being considered is a mesenchyme
if m_cell(c_xnew,c_ynew) ~= -1
    'A cell other than a mesenchyme is being considered by the function f_allindices_allnearby_m'
end

% Get all the possible indices regardless of whether they are occupied or
% not
m_mesenchyme_starting = f_allindices_allnearby_all_m(c_xold,c_yold,c_xnew,c_ynew,m_cell,v_parameters);


% Now go through those cells and remove those ones that are occupied by
% either epithelium or mesenchyme
m_mesenchyme = f_allindices_filter_m(m_mesenchyme_starting,m_cell);

% Dependent on the number of available moves, return a 1 or zero dependent
% on whether there are allowed moves or not
cn_meslen = length_new(m_mesenchyme);
c_allowed = 1;
if cn_meslen == 0
    c_allowed = 0;
    return;
end
    
