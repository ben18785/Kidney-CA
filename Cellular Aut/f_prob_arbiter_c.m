function c_success = f_prob_arbiter_c(c_prob)
% A function  which takes a probability as an input, compares it to a
% uniform random number on (0,1), yielding 1 if the input is greater, 0
% otherwise.
c_success = 0;

% Generate unif(0,1) random variable
c_ra = rand();

if c_prob > c_ra
    c_success = 1;
end