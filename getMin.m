function min_idx = getMin(W)
    N = size(W,2);
    deltaI_min = realmax;
    min_idx = 1;
    for i = 1 : N/2 - 1
        a = W(1,i); % note W(z_i | 0) = W(zhat_i | 1)
        b = W(2,i); % and  W(z_i | 1) = W(zhat_i | 0)
        a_p = W(1,i+1);
        b_p = W(2,i+1);
        deltaI = calcDeltaI(a,b,a_p,b_p);

        if deltaI < deltaI_min
            deltaI_min = deltaI;
            min_idx = i;
        end
    end
end