function W = degrading_merge(W, mu) 
    N = size(W,2);
    % Q(1,2k-1) = Q(y_i|0)    // Q(2,2k-1) = Q(y_i|1)  
    % Q(1,2k)   = Q(yhat_i|0) // Q(2,2k)   = Q(yhat_i|1)   
    while N > mu
        
        min_idx = getMin(W);
        
        % W(y|0)
        a_plus = W(1, min_idx) + W(1, min_idx + 1); % d.a + d.a'
        b_plus = W(2, min_idx) + W(2, min_idx + 1); % d.b + d.b'
        
        W(1, min_idx) = a_plus; 
        W(2, min_idx) = b_plus;

        % yhat - y conjugate is mirrored because of the ordering of LR
        % N - min_idx is conjugate of min_idx + 1
        % N - min_idx - 1 is conjugate of min_idx
        ahat_plus = W(1, N - min_idx + 1) + W(1, N - min_idx); 
        bhat_plus = W(2, N - min_idx + 1) + W(2, N - min_idx); 
        
        W(1, N - min_idx + 1) = ahat_plus; 
        W(2, N - min_idx + 1) = bhat_plus;
        
        W(:, min_idx + 1) = []; % merging to new symbol, remove min idx 
        W(:, N - min_idx - 1) = []; % -1 since we already removed one index
        N = size(W, 2);
        
    end
    

end


    
