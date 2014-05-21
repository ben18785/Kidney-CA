function c_allowed = f_mesenchyme_engulfment_c(m_mesenchyme,m_cell,v_parameters)
% A function which determines whether any of the neighbouring mesenchyme
% will become engulfed in the current set up. It returns 1 if everything is
% ok (no engulfment), and 0 otherwise.

cn_nummes = length_new(m_mesenchyme);

c_allowed = 1;
for i = 1:cn_nummes
    c_temp = f_mesenchyme_indiv_engulf_c(m_mesenchyme(i,1),m_mesenchyme(i,2),m_cell,v_parameters);
    if c_temp == 0 % If not allowed
        c_allowed = 0;
        return;
    end
end