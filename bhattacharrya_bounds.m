function idx = bhattacharrya_bounds(N, K, EbN0_db)
    n = log2(N);
    S = 10^(EbN0_db/10);

    z = zeros(N,1);
    z(1) = -S;

    for j=1:n
        u=2^j;
        for t=1:u/2
            T = z(t);
            z(t) = logdomain_diff( log(2)+T, 2*T );  %  2z - z^2
            z(u/2 + t) = 2*T;                        %  z^2
        end
    end
    plot(1:N, z, 'x');
    [~,idx] = maxk(z, N-K);
end

function z=logdomain_diff(x,y)
%     x > y
% x MUST be greater than y
%
z = x + log(1 - exp(y-x));
end