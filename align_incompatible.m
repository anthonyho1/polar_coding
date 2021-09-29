function u = align_incompatible(u, incompatible, enc_orders, block_size, recursions)
    blocks = length(u) / block_size;
    total_length = u;
    
    incompatible = flip(incompatible); % assumes incompatible(1) is smallest
 
    for i = 1:recursions 
        ordering = enc_orders(i,:);
        ordering = ordering(1:find(ordering,1,'last')); % zero-padded, get non zeros 
        N = length(ordering); 
        num_blocks = total_length / N;
        incomp_idx = cell2mat(incompatible(i));
        
        if num_blocks == 1 
            u = u(ordering);
            u(incomp_idx(1,:)) = mod(u(incomp_idx(1,:)) + u(incomp_idx(2,:)+N/2),2);
        else 
            for b = 0:num_blocks-1
                temp_u = u(N*b+1:N*b+N);
                temp_u = temp_u(ordering);
                temp_u(incomp_idx(1,:)) =  mod(temp_u(incomp_idx(1,:)) + temp_u(incomp_idx(2,:)+N/4),2);
                temp_u(incomp_idx(1,:)+N/2) =  mod(temp_u(incomp_idx(1,:)+N/2) + temp_u(incomp_idx(2,:)+3*N/4),2);
                
                u(N*b+1:N*b+N) = temp_u;
            end
            
        end

    end
    
                                        
end

