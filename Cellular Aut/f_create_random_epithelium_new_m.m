function m_cell = f_create_random_epithelium_new_m(m_cell, c_xstart, c_ystart, cn_epithelium_cells,v_parameters)
% A function which creates a random epithelium with a relatively smooth
% boundary which is curvy by starting with a random location near the 

c_xstart = round(c_xstart);
c_ystart = round(c_ystart);

% Generate a cell in the centre
m_cell(c_xstart,c_ystart) = 1;
m_cell(c_xstart,c_ystart+1) = 1;


% Now find the 
for i = 1:cn_epithelium_cells
    % Find the indices available to move into
    m_allindices = f_allindices_8neigh_m(c_xstart,c_ystart,v_parameters);
    
    % Select the only relevant ones
    [~,m_allowedindices] = f_epithelium_allowedspecific_cm(c_xstart,c_ystart,m_allindices,m_cell,v_parameters,1);
    
    cn_numindices = size(m_allowedindices);
    cn_numindices = cn_numindices(1);
    
    if cn_numindices > 0
    
        % Choose an index randomly
        cr_a = randi(cn_numindices,1);

        % Update the indices
        c_xstart = m_allowedindices(cr_a,1);
        c_ystart = m_allowedindices(cr_a,2);

        % Create a cell there
        m_cell(c_xstart,c_ystart) = 1;

    else % If there are no available moves, pick another cell at random as the new starting location
        m_cellindices = f_cellindices_all_m(m_cell);
        
        cn_available_epithelium = size(m_cellindices);
        cn_available_epithelium = cn_available_epithelium(1);
        
        % Choose an index randomly
        cr_a = randi(cn_available_epithelium,1);

        % Update the indices
        c_xstart = m_cellindices(cr_a,1);
        c_ystart = m_cellindices(cr_a,2);
    end
end

% First of all make all the components of the image which are not 1 zero
m_cell = m_cell.*(m_cell==1);

se = strel('ball',10,10);
m_cell = imdilate(m_cell,se);
m_cell = double((m_cell>10)); % Important as otherwise the array is a logical one!