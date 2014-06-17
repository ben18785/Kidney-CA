function c_prob_transform = f_epithelium_ret_GDNF_prob_c(c_x,c_y,m_GDNF,v_parameters,c_epithelium_type)
% A function which determines the probability that an epithelium cell
% transforms from retL-> retH or vice versa, dependent on the type of cell
% being selected. The function should only be called if the cell type is
% allowed to go through transformation, so there is no need to check.

switch c_epithelium_type
    case 1 % retL
        C0 = v_parameters(49);
        C1 = v_parameters(50);
    case 2 % retH
        C0 = v_parameters(49);
        C1 = v_parameters(50);
end


c_prob_transform = normcdf(C0+C1*m_GDNF(c_x,c_y));