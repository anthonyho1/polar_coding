function [incompatible, dec_orders, enc_orders] = get_aligned_structure(type2, type3, blocks, N, recursions)
    % for u: use ceil(recursions/2)
    % for v: use floor(recursions/2) for recursions
%     dec_orders = {};
    dec_orders = zeros(recursions, blocks*N);
    
%     enc_reorder = {};
    enc_orders = zeros(recursions, blocks*N);
    incompatible = {[type2;type3]};
    
    for i = 1:recursions
        type3 = type3 + N;
        if blocks == 2
         
            order = get_2_block_decoding_order(type2, type3, N);
            N = 2*N;
            dec_orders(i, 1:N) = order;
            
            [~,reorder] = sort(order); % encoding reorder
            enc_orders(i, 1:N) = reorder;
            
            break
        end
        [type2, type3, order] = get_decoding_order(type2, type3, N);
        N = 4*N;
        
        dec_orders(i, 1:N) = order;
        
        [~,reorder] = sort(order); % encoding reorder
        enc_orders(i, 1:N) = reorder;
        
        incompatible{end+1} = [type2;type3]; 
        
        
        blocks = blocks/4;
    end
    enc_orders = flip(enc_orders,1);
end