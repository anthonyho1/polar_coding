% assumes type 2 is in range 1:N  and type3 is in range N+1:2N
% for final recursion in the case we have 2 blocks left to combine
function order = get_2_block_decoding_order(type2, type3, N)

    order = zeros(1,2*N);
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

        end
        
        block_seg_2 = type3(i) - prev_type3 - 1;
        if block_seg_2 > 0
            order(head:head+block_seg_2-1) = block2_head:(type3(i)-1); %block 2
            head = head+block_seg_2;

        end
        % 1->2->3->4 order for the incompatible indices
        order(head:head+1) = [type2(i) type3(i)];
        head = head+2;
        block1_head = type2(i)+1;
        block2_head = type3(i)+1;
        prev_type2 = type2(i);
        prev_type3 = type3(i);
        
    end
    % remaining indices

    if head < 2*N
        remaining_len = N - block1_head;
        if remaining_len >= 0
            order(head:head+remaining_len) = block1_head:N; %block 1
            head = head+remaining_len+1;
        end
        remaining_len = 2*N - block2_head;
        if remaining_len >= 0
            order(head:head+remaining_len) = block2_head:2*N; %block 2
            head = head+remaining_len+1;
        end
    end

end 