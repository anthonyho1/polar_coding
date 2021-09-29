function out = awgn_channel_noise(s, EbN0_dB)
    EbN0 = 10^(EbN0_dB/10);
    N0 = 1/EbN0;
    
    n = randn(size(s)); 
    
    out = s + sqrt(N0/2) * n;
end