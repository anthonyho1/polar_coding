% assumes type 2 is in range 1:N  and type N+1:2N
% assumes length(type2) = length(type3)
function [new_type2, new_type3, order] = get_decoding_order(type2, type3, N)

    order = zeros(1,4*N);
    block1_head = 1;
    block2_head = N+1;
    head = 1;
    prev_type2 = 0; % previous incompatible index (type2)
    prev_type3 = N; 
    for i = 1:length(type2)
        % priority goes 1 -> 3 -> 2 -> 4 (arbitrary, can go 1->2->3->4 if you wanted)

        block_seg_1 = type2(i) - prev_type2 - 1; %length between two type2 indices
        if block_seg_1 > 0
            order(head:head+block_seg_1-1) = block1_head:(type2(i)-1); % block 1
            head = head+block_seg_1;
            
            order(head:head+block_seg_1-1) = (block1_head:type2(i)-1) + 2*N; % block 3
            head = head+block_seg_1;   %blocks 1 & 3 are copies 
        end
        
        block_seg_2 = type3(i) - prev_type3 - 1;
        if block_seg_2 > 0
            order(head:head+block_seg_2-1) = block2_head:(type3(i)-1); %block 2
            head = head+block_seg_2;
            
            order(head:head+block_seg_2-1) = (block2_head:type3(i)-1) + 2*N; %block 4
            head = head+block_seg_2; %blocks 1 & 3 are copies
        end
        % 1->2->3->4 order for the incompatible indices
        order(head:head+3) = [type2(i) type3(i) (type2(i)+2*N) (type3(i)+2*N)];
        head = head+4;
        block1_head = type2(i)+1;
        block2_head = type3(i)+1;
        prev_type2 = type2(i);
        prev_type3 = type3(i);
        
    end
    % remaining indices

    if head < 4*N
        remaining_len = N - block1_head;
        if remaining_len >= 0
            order(head:head+remaining_len) = block1_head:N; %block 1
            head = head+remaining_len+1;
            
            order(head:head+remaining_len) = (block1_head:N) + 2*N; %block 3
            head = head+remaining_len+1;
        end
        remaining_len = 2*N - block2_head;
        if remaining_len >= 0
            order(head:head+remaining_len) = block2_head:2*N; %block 2
            head = head+remaining_len+1;
            
            order(head:head+remaining_len) = (block2_head:2*N) + 2*N; %block 4
        end
    end

    [~,idx] = sort(order);
%     type2_new = [type2+N type2+3*N]
%     type3_new = [type3-N type3+N]
    old_incomp = [idx(type2) ; idx(type3)]
    new_type2 = sort(idx([type2+N type2+3*N]))
    new_type3 = sort(idx([type3-N type3+N]))
    
end 