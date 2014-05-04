function [cn_connections,m_connections] = f_findconnectedcomponents_m(c_x,c_y,m_cell,v_parameters)
% A function which works out which cells a given cell is connected to, if
% any

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
cn_connections = 0;
k = 1;
if and(c_x>1,c_x<c_depth_full)
    if m_cell(c_x-1,c_y) == 1 % Bottom
        m_connections(k,:) = [c_x-1,c_y];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    if m_cell(c_x,c_yright) == 1  % Right
        m_connections(k,:) = [c_x,c_yright];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    if m_cell(c_x,c_yleft) == 1 % Left
        m_connections(k,:) = [c_x,c_yleft];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    if m_cell(c_x+1,c_y) == 1 % Top
        m_connections(k,:) = [c_x+1,c_y];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
elseif c_x==1
    if m_cell(c_x,c_yright) == 1  % Right
        m_connections(k,:) = [c_x,c_yright];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    if m_cell(c_x,c_yleft) == 1 % Left
        m_connections(k,:) = [c_x,c_yleft];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    if m_cell(c_x+1,c_y) == 1 % Top
        m_connections(k,:) = [c_x+1,c_y];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    
elseif c_x==c_depth_full
    if m_cell(c_x-1,c_y) == 1 % Bottom
        m_connections(k,:) = [c_x-1,c_y];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    if m_cell(c_x,c_yright) == 1  % Right
        m_connections(k,:) = [c_x,c_yright];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
    if m_cell(c_x,c_yleft) == 1 % Left
        m_connections(k,:) = [c_x,c_yleft];
        cn_connections = cn_connections + 1;
        k = k + 1;
    end
else
    c_x
    'Something has gone wrong. X Is taking on a value that it shouldnt in f_findconnectedcomponents_m'
    return;
end

