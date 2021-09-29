clear 

N = 2048;
% K = 512;
rate_seq = 0.1:0.05:0.9;
K_seq = ceil(rate_seq * N);
K_seq_len = length(K_seq);

ebn0_sequence = 3.5:0.5:5.5;
g_seq = [0.1 0.5 0.9];

BER1 = zeros(length(K_seq), length(K_seq), length(g_seq));
BER2 = zeros(length(K_seq), length(K_seq), length(g_seq));
% num_errors = zeros(length(ebn0_sequence),1);

Rm = 1; %BPSK
% ebn0_num = 10.^(ebn0/10);
% SNR = ebn0 + 10*log10(Rc*Rm) + 10*log10(2);
% SNR_num = 10.^(SNR/10);
% g = 0.3; % interference strength
frames = 100;
EbN0_dB = 3;

EbN0 = 10^(EbN0_dB/10);
N0 = 1/(EbN0);

for l = 1:length(g_seq)
    g = g_seq(l);
    file_name = "code_constructions/prob_error_N_" + N + "_g_0_" + int8(g*10) + "_SNR_" + EbN0_dB + ".txt";
    
%     Pe = get_frozen_bits_interference(EbN0_dB, g, N); % tal-vardy algorithm
    Pe = readmatrix(file_name);
    parfor i = 1:K_seq_len
        K_1 = K_seq(i);
        % iterate through different rates K
        for j = 1:K_seq_len
            K_2 = K_seq(j);
            disp(['g = ' num2str(g) ' // K1 = ' num2str(rate_seq(i)) ' // K2 = ' num2str(rate_seq(j))]);
             % frozen bits
            [~,frozen_idx_1] = maxk(Pe, N - K_1);
            [~,frozen_idx_2] = maxk(Pe, N - K_2);

            frozen_bits_1 = zeros(N,1);
            frozen_bits_1(frozen_idx_1) = 1;
            
            frozen_bits_2 = zeros(N,1);
            frozen_bits_2(frozen_idx_2) = 1; 

            errors_1 = 0;
            errors_2 = 0;
            
            for k = 1:frames
                
                u_before_1 = randi([0 1],1,K_1);
                u_before_2 = randi([0 1],1,K_2);
                enc_msg1 = pc_encoder(N, u_before_1, frozen_idx_1);
                enc_msg2 = pc_encoder(N, u_before_2, frozen_idx_2);

                bpsk_sig1 = bpsk_modulator(enc_msg1);
                bpsk_sig2 = bpsk_modulator(enc_msg2);

                [out_awgn1, out_awgn2] = awgn_interference_channel(bpsk_sig1, bpsk_sig2, EbN0_dB, EbN0_dB, g);

                [u_after_1, v_after_1] = pc_decoder(out_awgn1, frozen_bits_1);
                
                out_awgn2 = out_awgn2 - g * u_after_1;
                [u_after_2, v_after_2] = pc_decoder(out_awgn2, frozen_bits_2);

                u_after_1(frozen_idx_1)=[];
                u_after_2(frozen_idx_2)=[];

                errors_1 = errors_1 + sum(u_after_1 ~= u_before_1);
                errors_2 = errors_2 + sum(u_after_2 ~= u_before_2);
                
            end
            
            BER2(i,j,l) = errors_2 / (K_2 * frames); % bit error rates for given rate1 and rate2, and interference g
            BER1(i,j,l) = errors_1 / (K_1 * frames);

        end    
    end
end
% TODO: PRINT TO FILE 
colors = {'r', 'g', 'b', 'c', 'm', 'y', 'k', [0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250]};
markers = {'o', '^',  '*', 'v', 's', 'd', 'x', 'p', 'h'};

figure(1); clf; hold on;
for k = 1:length(g_seq)
    achievable_rates = [];
    for i = 1:length(K_seq)
        for j = 1:length(K_seq)
            if BER1(i,j,k) < 10^-3 && BER2(i,j,k) < 10^-3
                achievable_rates = [achievable_rates; rate_seq(i) rate_seq(j)]; % only plots achievable rates
            end
        end
    end
    outer_idx = boundary(achievable_rates,1);
    
    plot(achievable_rates(outer_idx,1),achievable_rates(outer_idx,2), 'LineStyle', 'none', 'Marker', markers{k}, 'Color', colors{k});
end
title('Achievable Rate Region for SC (N=2048, g=0.1/0.5/0.9, SNR = 3 dB')
% legend;
ylabel("Rate 2");
xlabel("Rate 1");
hold off;

function out = bpsk_modulator(u)
    out = 1 - 2 * u;
end 
