function [c_allowed,m_available_restricted_mesenchyme] = f_mesenchyme_disallow_surrounded_m(c_x,c_y,m_cell,m_available_mesenchyme,v_parameters)
% A function which takes the possible moves available to the mesenchyme,
% and removes any possible moves which would result in the mesenchyme being
% partially surrounded by epithelium. Disallow moves which result in the
% number of nearest neighbours surrounding the moved mesenchyme exceed 
% c_mes_trapped. (c_x,c_y) is usually the
% current position of the mesenchyme.

% Create a copy of m_cell for hypothetical testing
m_cell_copy = m_cell;

% Set the cell at the mesenchyme's current position to be a epithelium, and
% don't set the old cell to zero. This is a bit overly restrictive, but is due to the fact that
% we don't know where the epithelium is coming from. This is ok since this is
% implemented after the function which checks for available indices,
% meaning that the mesenchyme won't just swap places with the moving
% epithelium
m_cell_copy(c_x,c_y) = 1;


% Get the number of available mesenchyme moves
c_nummoves = length_new(m_available_mesenchyme);

% Go through and check each of the available move positions, and add them
% to the list of available moves iff there are c_mes_trapped or fewer
% 8-nearest-neighbours of epithelium
m_available_restricted_mesenchyme = zeros(c_nummoves,2);
k = 1;
for i = 1:c_nummoves
    c_nottrapped = f_mesenchyme_trapped_check_c(m_available_mesenchyme(i,1),m_available_mesenchyme(i,2),m_cell_copy,c_x,c_y,v_parameters);

   if c_nottrapped == 1 % If not trapped, add the move to the list of available moves
       m_available_restricted_mesenchyme(k,:) = [m_available_mesenchyme(i,1),m_available_mesenchyme(i,2)];
       k = k + 1;
   end
    
end

% Remove any zero entries
m_available_restricted_mesenchyme = remove_zeros(m_available_restricted_mesenchyme);

% If there are allowed moves, then return a 1, else zero
c_allowed = 0;
if k > 1
    c_allowed = 1;
end