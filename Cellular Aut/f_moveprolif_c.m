function cp_move = f_moveprolif_c(ck_moveprob)
% A function which returns 1 if a move is chosen, or 0 if a proliferation
% is chosen. This is done probabilistically via ck_moveprob



cr_a = rand();

if ck_moveprob > cr_a
    cp_move = 1;
else
    cp_move = 0;
end