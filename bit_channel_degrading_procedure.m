function Pe = bit_channel_degrading_procedure(W, z, miu)
N = length(z);
if N == 1
    Pe = 0.5 * sum(min(W));
    disp(['Bit index = ' num2str(z) '  Error rate = ' num2str(Pe)])
else
    W_up = get_W_up(W);
    W_up = LR_sort(W_up);
    W_up_after_erasure_symbol_merge = erasure_symbol_merge(W_up);
    W_up_after_merge = degrading_merge2(W_up_after_erasure_symbol_merge, miu);
    Pe1 = bit_channel_degrading_procedure(W_up_after_merge, z(1 : N/2), miu);

    W_down = get_W_down(W);
    W_down = LR_sort(W_down);
    W_down_after_erasure_symbol_merge = erasure_symbol_merge(W_down);
    W_down_after_merge = degrading_merge2(W_down_after_erasure_symbol_merge, miu);
    Pe2 = bit_channel_degrading_procedure(W_down_after_merge, z(N/2 + 1 : end), miu);
    
    Pe = [Pe1 Pe2];
end
end

function W_up = get_W_up(W)
N = size(W, 2);
W_up = zeros(2, N^2);
for u1 = 0 : 1
    for y1 = 1 : N
        for y2 = 1 : N
            W_up(u1 + 1, N * (y1 - 1) + y2) = 0.5 * (W(u1 + 1, y1) * W(1, y2) + W(mod(u1 + 1, 2) + 1, y1) * W(2, y2));
        end
    end
end
end

function W_down = get_W_down(W)
N = size(W, 2);
W_down = zeros(2, 2 * N^2);
for u2 = 0 : 1
    for y1 = 1 : N
        for y2 = 1 : N
            for u1 = 0 : 1
                W_down(u2 + 1, 2 * N * (y1 - 1) + 2 * (y2 - 1) + u1 + 1) = 0.5 * W(mod(u1 + u2, 2) + 1, y1) * W(u2 + 1, y2);
            end
        end
    end
end
end

function V = LR_sort(W)
N = size(W, 2);
LLR = zeros(1, N);
for i = 1 : N
    if (W(1, i) ~= 0) && (W(2, i) ~= 0)
        LLR(i) = log(W(1, i)) - log(W(2, i));
    else
        if (W(1, i) == 0) && (W(2, i) ~= 0)
            LLR(i) = -inf;
        else
            if (W(1, i) ~= 0) && (W(2, i) == 0)
                LLR(i) = inf;
            end
        end
    end
end
[~, ordered]  = sort(LLR, 'descend');
V = W(:, ordered);
end

function V = erasure_symbol_merge(W)
cnt = 0;
N = size(W, 2);
for i = N/2 : -1  : 1
    if W(1, i) == W(2, i)
        cnt = cnt + 1;
    else
        break;
    end
end
W_erasure = W(:, N/2 - cnt + 1 : N/2 + cnt);
erasure_probability = sum(W_erasure(1, :));
middle = erasure_probability/2 * ones(2, 2);
W_left = W(:, 1 : N/2 - cnt);
W_right = W(:, N/2 + cnt + 1 : end);
V = [W_left middle W_right];
end

function W = degrading_merge2(W, miu)
N = size(W, 2);%N is not a constant if merge is needed
if N <= miu
    return
else  
    while(N > miu)
        min_deltaI = realmax;
        min_index = 0;
        for i = 1 : N/2 - 1
            a1 = W(1, i);
            b1 = W(2, i);
            a2 = W(1,i + 1); 
            b2 = W(2, i + 1);
            deltaI = capacity(a1, b1) + capacity(a2, b2) - capacity(a1 + a2, b1 + b2);

            if deltaI < min_deltaI %find minimum delta I
                min_deltaI = deltaI;
                min_index = i;
            end
        end
        

        W(1, min_index) =  W(1, min_index) + W(1, min_index + 1);
        W(2, min_index) =  W(2, min_index) + W(2, min_index + 1);
        W(1, N - min_index + 1) =  W(1, N - min_index + 1) + W(1, N - min_index);
        W(2, N - min_index + 1) =  W(2, N - min_index + 1) + W(2, N - min_index);
        W(:, min_index + 1) = [];
        W(:, N - min_index - 1) = [];
        N = size(W, 2);
    end
end
end

function z = capacity(x, y)

if (x ~= 0) && (y ~= 0)
    z = -(x + y) * log2((x + y)/2) + x * log2(x) + y * log2(y);
else
    if (x == 0) && (y ~= 0)
        z = y;
    else
        if (y == 0) && (x ~= 0)
            z = x;
        else
            z = 0;
        end
    end
end

end