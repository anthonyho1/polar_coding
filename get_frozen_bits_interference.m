function Pe = get_frozen_bits_interference(SNR_dB, g, N) 
    mu = 32;
    nu = mu /2;
    
    W = discretize_interference_channel(SNR_dB, g, nu);
%     SNR = 10^(SNR_dB/10);
%     sigma = 1/sqrt(2*SNR)
%     W = get_AWGN_transition_probability(sigma, nu);
    W = degrading_merge(W, mu);
%     Pe = bit_channel_degrading_procedure(W, 1:N, mu); 
    Pe = bit_channel_degrading(W, 1:N, mu); 
    
%     plot(1:N, Pe, 'x');
%     [~,frozen_idx] = maxk(Pe, N-K);
end