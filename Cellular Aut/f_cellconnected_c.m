function c_connected = f_cellconnected_c(c_x,c_y,m_cell,v_parameters)
% A function which determines if a cell is connected in the simulation
% area; returning a 1 if it is, and 0 if not

% Make a copy so that we can just look at Ret-high and Ret-low together;
% forgetting about having to amend the rules to take their identity into
% account
m_cell = double(m_cell>0);

% Get the dimensions of the matrix being used
c_depth_full = v_parameters(6);
c_width_full = v_parameters(7);

% Work out the y coordinates for use in modulo arithmetic to give the
% neighbouring coordinates
c_y = c_y - 1;

c_yright = mod(c_y+1,c_width_full);
c_yleft = mod(c_y-1,c_width_full);

% Re-transform
c_yright = c_yright + 1;
c_yleft = c_yleft + 1;

% Transform the c_y back
c_y = c_y + 1;

% Work out whether the new cell is connected by looking at its top, right,
% left and below neighbours
c_connected = 0;
if and(c_x>1,c_x<c_depth_full)
    if m_cell(c_x-1,c_y) == 1 | m_cell(c_x,c_yright) == 1 | m_cell(c_x,c_yleft) == 1 | m_cell(c_x+1,c_y) == 1 % Bottom, right, left, top have cells?
        c_connected = 1;
    end 
elseif c_x==1
    if m_cell(c_x,c_yright) == 1 | m_cell(c_x,c_yleft) == 1 | m_cell(c_x+1,c_y) == 1 % Right, left, top have cells?
        c_connected = 1;
    end
elseif c_x==c_depth_full
    if m_cell(c_x-1,c_y) == 1 | m_cell(c_x,c_yright) == 1 | m_cell(c_x,c_yleft) == 1
        c_connected = 1;
    end
    
else
    'Something has gone wrong. X Is taking on a value that it shouldnt in f_activeconnected'
    return;
    
end