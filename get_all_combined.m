function combined_idx = get_all_combined(incompatible, dec_orders, N, blocks, recursions)
    combined_idx = [];
    previous = [];
    for i = 1:recursions
        inc_idx = cell2mat(incompatible(i));
        idx_per_block = size(inc_idx,2);
        
        combined = [];
        if blocks == 2 
            ordering = dec_orders(i, 1:2*N);
            comb = [inc_idx(1,:)+j*N; inc_idx(2,:)+(1+j)*N];
            
            combined = [combined comb];
            
            combined_idx = ordering(combined);
            break 
        end
        ordering = dec_orders(i, 1:4*N);
        for j = 0:4:blocks-1
            comb = [previous [inc_idx(1,:)+j*N inc_idx(1,:)+(2+j)*N; inc_idx(2,:)+(1+j)*N inc_idx(2,:)+(3+j)*N]];
            comb = ordering(comb); 
            
            combined = [combined comb];
            
        end
        combined_idx = [combined_idx combined]; 
        
        N = 4*N;
        blocks = blocks/4;
    end




end