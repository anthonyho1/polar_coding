function Pe = get_error_probabilities(Q, mu, N)
    Pe = zeros(1,N);
    for i = 1:N
        if mod(i,100) == 0 
            i
        end
        W = bit_channel_degrading(Q, mu, N, i);
        Pe(i) = 0.5 * sum(min(W(1,:),W(2,:)));
    end
end