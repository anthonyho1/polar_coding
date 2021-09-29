clc
clear 

N = 2^15
K = 2^14
SNR_db = 4.65

frozen_idx = bhattacharrya_bounds(N,K, SNR_db);
frozen_bits = zeros(N,1);
frozen_bits(frozen_idx) = 1;

u_before = randi([0 1],1,K);
enc_msg = pc_encoder(N, u_before, frozen_idx);

bpsk_sig = 1 - 2*enc_msg;

out_awgn = awgn_channel_noise(bpsk_sig, SNR_db);

SNR = 10^(SNR_db/10);
var = 1/(2*SNR);

[u_after, v_after] = pc_decoder(out_awgn, frozen_bits);
% [u_after, h] = pc_decoder2(out_awgn,frozen_bits,var);
u_after(frozen_idx)=[];
% h;

errors = sum(u_after ~= u_before)

errorp = errors/K

function out = bpsk_modulator(u, power_db)
    power = 10^(power_db/10);
    out = sqrt(power) * (1 - 2 * u);
end 
