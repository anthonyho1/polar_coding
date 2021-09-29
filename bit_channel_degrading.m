% recursively goes through the bits
function P_e = bit_channel_degrading(W, bit_array, mu)
    N = length(bit_array);
    if N == 1
        P_e = 0.5 * sum(min(W));
%         disp("bit index: " + num2str(bit_array) + " // Pe = " + num2str(P_e));
    else
        W_minus = W_minus_channel(W);
        W_sorted_minus = LR_sort(W_minus);
        W_erasure_minus = erasure_merge(W_sorted_minus);
        W_merged_minus = degrading_merge(W_erasure_minus, mu);
        Pe_minus = bit_channel_degrading(W_merged_minus, bit_array(1:N/2), mu);

        W_plus = W_plus_channel(W);
        W_sorted_plus = LR_sort(W_plus);
        W_erasure_plus = erasure_merge(W_sorted_plus);
        W_merged_plus = degrading_merge(W_erasure_plus, mu);
        Pe_plus = bit_channel_degrading(W_merged_plus, bit_array(N/2+1 : end), mu);
        
        P_e = [Pe_minus Pe_plus]; 
    end
    
end




% does this iteratively, in O(nmt) time, where tau = degrading_merge time
% called by get_error_probabilities
% function W = bit_channel_degrading(W, mu, n, idx)
%     m = log2(n)+1; % codelength 2^m
%     b = de2bi(idx, m);
%     W = degrading_merge(W, mu);
%     
%     for j = 1:m
%        
%        W_sorted = sort_LR(W);
%        if b(j) == 0 
%            W = W_minus_channel(W_sorted);
%        else 
%            W = W_plus_channel(W_sorted);
%        end
%        W = degrading_merge(W, mu);
%     end
% end 
