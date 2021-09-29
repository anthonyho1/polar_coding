clear 

N = 128;
% K = 512;
rate_seq = 0.1:0.1:0.6;
K_seq = ceil(rate_seq * N);

ebn0_sequence = 3.5:0.5:5.5;
g_seq = 0.1:0.1:0.9;

BER1 = zeros(length(g_seq),length(K_seq));
BER2 = zeros(length(g_seq),length(K_seq));
% num_errors = zeros(length(ebn0_sequence),1);

Rm = 1; %BPSK
% ebn0_num = 10.^(ebn0/10);
% SNR = ebn0 + 10*log10(Rc*Rm) + 10*log10(2);
% SNR_num = 10.^(SNR/10);
% g = 0.3; % interference strength
frames = 100;
EbN0_dB = 3;

% iterate through interference strength
for i = 1:length(g_seq)
    g = g_seq(i)
    
    EbN0 = 10^(EbN0_dB/10);
    N0 = 1/(EbN0);
    SINR = 1/(g^2 + N0/2);
    SINR_dB = 10*log10(SINR);
    
    Pe = get_frozen_bits_interference(EbN0_dB, g, N);
 
    % iterate through different rates K
    for j = 1:length(K_seq)
    %     EbN0_dB = ebn0_sequence(i)
        K = K_seq(j);

        [~,frozen_idx] = maxk(Pe, N-K);

        errors_1 = 0;
        errors_2 = 0;

        for k = 1:frames
            u_before_1 = randi([0 1],1,K);
            u_before_2 = randi([0 1],1,K);
            enc_msg1 = pc_encoder(N, u_before_1, frozen_idx);
            enc_msg2 = pc_encoder(N, u_before_2, frozen_idx);
            frozen_bits = zeros(N,1);
            frozen_bits(frozen_idx) = 1;

            bpsk_sig1 = bpsk_modulator(enc_msg1);
            bpsk_sig2 = bpsk_modulator(enc_msg2);

            [out_awgn1, out_awgn2] = awgn_interference_channel(bpsk_sig1, bpsk_sig2, EbN0_dB, EbN0_dB, g);

            [u_after_1, v_after_1] = pc_decoder(out_awgn1, frozen_bits);
            [u_after_2, v_after_2] = pc_decoder(out_awgn2, frozen_bits);

            u_after_1(frozen_idx)=[];
            u_after_2(frozen_idx)=[];

            errors_1 = errors_1 + sum(u_after_1 ~= u_before_1);
            errors_2 = errors_2 + sum(u_after_2 ~= u_before_2);
        end
        
        BER1(i,j) = errors_1 / (K * frames);
        BER2(i,j) = errors_2 / (K * frames);

    end    
end

colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250]};
figure(1); clf; hold on;
for i = 1:length(K_seq)
    semilogy(g_seq,BER1(:,i), '-o', 'Color', colors{i}, 'DisplayName', ['Rate = ' num2str(rate_seq(i))]);
    semilogy(g_seq,BER2(:,i), '--o', 'Color', colors{i}, 'HandleVisibility','off');
end
title('BER vs Interference Strength (g) for different rates K/N')
legend;
ylabel("BER");
xlabel("g");
hold off;

function out = bpsk_modulator(u)
    out = 1 - 2 * u;
end 
