% Assumes BPSK signal with unity average power
% since 1/N sum(x^2) for BPSK = 1
% 
function [out1, out2, SINR_dB_1, SINR_dB_2] = awgn_interference_channel(sig1, sig2, ebn0_db_1, ebn0_db_2, g)
    if length(sig1) ~= length(sig2)
        error('Error. Differing message lengths')
    elseif g < 0 
        error('Error. g must be strictly positive')
    else
        ebn0_1 = 10^(ebn0_db_1/10);
        ebn0_2 = 10^(ebn0_db_2/10);
        
        N0_1 = 1/(ebn0_1);
        N0_2 = 1/(ebn0_2);

        n_1 = sqrt(N0_1/2) * randn(size(sig1)); 
        n_2 = sqrt(N0_2/2) * randn(size(sig2)); 

        out1 = sig1 + g * sig2 + n_1;
        out2 = sig2 + g * sig1 + n_2;
        
    end
end