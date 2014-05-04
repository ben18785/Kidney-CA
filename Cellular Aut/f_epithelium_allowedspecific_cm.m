function [c_allowed,m_allowedindices] = f_epithelium_allowedspecific_cm(c_x,c_y,m_allindices,m_cell,v_parameters)
% A function which takes all the possible indices, and sorts these down to
% only those which are 'allowed' under each particular set of rules. ck_movement_rule specifes the rule: 
% 1 is allow all possible moves; 2 is don't allow movements into cells which
% are unconnected only for the active cell in question; 3 doesn't allow
% moves which create any cells which are unconnected (so not just for the active cell)

% Get the particular rule being used
ck_movement_rule = v_parameters(5);

% Now chose allowed cells in accordance with each of the rules
switch ck_movement_rule
    case 1 % All nonvacant cells are allowed
        [c_allowed,m_allowedindices] = f_epithelium_mrule1_cm(c_x,c_y,m_allindices,m_cell);
    case 2 % Vacant cells are allowed only if the cell which has moved is connected
        [c_allowed,m_allowedindices] = f_epithelium_mrule2_cm(c_x,c_y,m_allindices,m_cell);
    case 3 % Moves to vacant cells are only allowed if the resultant distribution of neighbouring cells are ALL fully connected
        [c_allowed,m_allowedindices] = f_epithelium_mrule3_cm(c_x,c_y,m_allindices,m_cell);
    otherwise 
        'An error has occurred. Please choose only 1,2,3 for the allowed movement rule'
        return;
end