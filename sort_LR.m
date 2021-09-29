%not sure if needed, looks like it's already sorted when getting the
% discretized channel
function Q = sort_LR(W)
    N = size(W, 2);
    LLR = zeros(1, N);
    for i = 1 : N 
%         W0 = W(1, 2*i-1);
%         W1 = W(2, 2*i-1);
        W0 = W(1, i);
        W1 = W(2, i);
        if (W0 ~= 0) && (W1 ~= 0)
            LLR(i) = log(W0) - log(W1);
        else
            if (W0 == 0) && (W1 ~= 0)
                LLR(i) = -inf;
            else
                if (W0 ~= 0) && (W1 == 0)
                    LLR(i) = inf;
                end
            end
        end
    end
    
    [~, sorted_idx]  = sort(LLR, 'descend');
    
    Q = W(:, sorted_idx);
end