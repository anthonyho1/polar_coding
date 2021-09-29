function W_minus = W_minus_channel(W)
    N = size(W, 2);
    W_minus = zeros(2, 2*N^2); %output alphabet is |Y|^2
    % eqn (5)
    for u1 = 0 : 1
        for y1 = 1 : N
            for y2 = 1 : N
                 % sum over u2
                W_minus(u1 + 1, N * (y1 - 1) + y2) ...
                    = 0.5 * W(u1 + 1, y1) * W(1, y2) + ... % u1 + 0 
                      0.5 * W(mod(u1 + 1, 2) + 1, y1) * W(2, y2); % u1 + 1
            end
        end
    end 
end
