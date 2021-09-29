function [dec_order, enc_order, combined_idx] = get_full_decoding_order(dec_orders, incompatible, blocks, N)
    order = 1:N;
    combined_idx = [];
    for i = 1:size(dec_orders,1)
        i
        if blocks == 2
            order = [order order+N];
            
            curr_dec_order = dec_orders(i, 1:2*N)
            order = order(curr_dec_order);
            
            [~,rev_order] = sort(curr_dec_order)
            
            incomp = cell2mat(incompatible(i));
            combined_idx = [combined_idx combined_idx+N [incomp(1,:); incomp(2,:)+N]]
        
            combined_idx = rev_order(combined_idx);
            break
        end
        
        order = [order order+N order+2*N order+3*N];
        curr_dec_order = dec_orders(i, 1:4*N)
        order = order(curr_dec_order);
%         order_t = order';
        [~,rev_order] = sort(curr_dec_order)
        
        
        incomp = cell2mat(incompatible(i))
        combined_idx = [combined_idx combined_idx+N combined_idx+2*N combined_idx+3*N ...
                        [incomp(1,:) incomp(1,:)+2*N; incomp(2,:)+N incomp(2,:)+3*N]];
        
        
        combined_idx = rev_order(combined_idx);
%         t2 = combined_idx(1,:)'
%         t3 = combined_idx(2,:)'
        blocks = blocks/4; 
        N = 4*N;

    end
    dec_order = order;
    [~,idx] = sort(order);
    enc_order = idx;

end