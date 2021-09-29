function enc_msg = pc_encoder(N, msg, frozen_idx)
    n = log2(N);
    uncoded_msg = zeros(N,1);
    uncoded_msg(setdiff(1:end,frozen_idx)) = msg;
    
    m = 1;
    u = uncoded_msg;
    for d = 1:n
        for i = 1:2*m:N 
            a = u(i:i+m-1);
            b = u(i+m:i+2*m-1);
            u(i:i+2*m-1) = [mod(a+b, 2) b];
        end
        m = 2*m;
    end
    enc_msg = bitrevorder(u');
%      enc_msg = u';
end

