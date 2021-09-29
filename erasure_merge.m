function V = erasure_merge(W)
    count = 0;
    N = size(W, 2);
    for i = N/2 : -1  : 1
        if W(1, i) == W(2, i)
            count = count + 1; % all erasure symbols will be in the middle
        else                   
            break;
        end
    end
    W_erasure = W(:, N/2 - count + 1 : N/2 + count); 
    erasure_prob = sum(W_erasure(1, :));   % sum all erasures to one 
    middle = erasure_prob/2 * ones(2, 2); % Question: still left with 1 
    W_left = W(:, 1 : N/2 - count);       % erasure symbol in the end?
    W_right = W(:, N/2 + count + 1 : end);
    V = [W_left middle W_right];
end