function W = discretize_interference_channel(SNR_dB, g, mu)
    SNR = 10^(SNR_dB/10);
    sigma = 1/sqrt(2*SNR)
    
    lambda = getLambda(mu);
    y_intervals = get_y_intervals(sigma, g, lambda);
    W = interference_channel_to_dmc(y_intervals, lambda, sigma, g, mu);
end 