function [c_allowed,m_mesenchyme_available] = f_mesenchyme_available_cm(c_x,c_y,m_allmesenchyme,m_cell,v_parameters)
% A function which takes all the available indices, and first removes all
% those that are occupied, then (dependent on the specific rule in place),
% checks whether that moves allows spaces for the mesechyme to move into. 1
% is returned if the moves are allowed. 0 if not. (c_x,c_y) is usually the
% current position of the mesenchyme.

% Find all nearest 8-NN which are vacant
[c_allowed,m_mesenchyme_available] = f_epithelium_mrule1_cm(c_x,c_y,m_allmesenchyme,m_cell,v_parameters);

% If disallowed return
if c_allowed == 0
    return;
end

% Get the rule being used
c_mes_allowed = v_parameters(19);


switch c_mes_allowed
    case 1
        return;% If the rule being used allows all vacant spaces, then just return
        
    case 2 % If the rule being used restricts the allowed targets for the mesenchyme, then check for whether there are any 'allowed' spaces
        [c_allowed,m_mesenchyme_available] = f_mesenchyme_disallow_surrounded_m(c_x,c_y,m_cell,m_mesenchyme_available,v_parameters);

end


