clear 

errorRate = comm.ErrorRate;
N = 1024;
K = 1024/2;
Rc = K/N;
ebn0_sequence = 1:0.5:3.5;
BER = zeros(length(ebn0_sequence),1);
% num_errors = zeros(length(ebn0_sequence),1);

Rm = 1; %BPSK
% ebn0_num = 10.^(ebn0/10);
% SNR = ebn0 + 10*log10(Rc*Rm) + 10*log10(2);
% SNR_num = 10.^(SNR/10);
rel_seq = nr5g.internal.polar.sequence;
[B,frozen_idx] = mink(rel_seq, N-K);

for i = 1:length(ebn0_sequence)
    EbN0_dB = ebn0_sequence(i)
    SNR_dB = EbN0_dB + 10*log10(Rc*Rm) + 10*log10(2);

%     frozen_idx = bhattacharrya_bounds(N,K, EbN0_dB);
    
    for j = 1:10000
        u_before = randi([0 1],K,1);
        enc_msg = pc_encoder(N, u_before, frozen_idx);
        frozen_bits = zeros(N,1);
        frozen_bits(frozen_idx) = 1;

        bpsk_sig = bpsk_modulator(enc_msg);

        out_awgn = awgn_channel_noise(bpsk_sig, EbN0_dB);
        %initial_LLRs = init_LLRs(out_awgn, noise_var); 
        %out_awgn = awgn(bpsk_sig, SNR_dB);

        [u_after, v_after] = pc_decoder(out_awgn, frozen_bits);

        u_after(frozen_idx)=[];

        errorStats = errorRate(u_before,u_after');
    end
    BER(i) = errorStats(1); 
    errorStats(2)
    reset(errorRate);
end
% fprintf('Error rate = %f\nNumber of errors = %d\n',errorStats(1), errorStats(2))

semilogy(ebn0_sequence,BER, "-o")

function out = bpsk_modulator(u)
    out = 1 - 2 * u;
end 

function out = bpsk_demodulator(u)
    out = 0 .* (u > 0) + 1 .* (u < 0);
end 

