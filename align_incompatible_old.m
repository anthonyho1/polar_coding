function [u, v, combined_u_total, combined_v_total] = align_incompatible_old(u_type2, u_type3, ...
                                            v_type2, v_type3, u, v, n_recursions, N)
    % 2^n_recursions = # of blocks
    % u = 
    % N = block length
    
    % make sure type 2 and type 3 lengths are equal
    [u_type2, u_type3] = equal_idx_lengths(u_type2, u_type3);
    [v_type2, v_type3] = equal_idx_lengths(v_type2, v_type3);
    
    num_u_idx = length(u_type2);
    num_v_idx = length(v_type2);
    
    num_blocks = length(u) / N
    
     % use this to keep track of uncombined blocks
     % uncombined_blocks(1,:) = type 2
     % uncombined_blocks(2,:) = type 3
%     uncombined_u = [1:num_blocks;1:num_blocks];
%     uncombined_v = [1:num_blocks;1:num_blocks];
    
    [uncomb_u_type2, uncomb_u_type3, uncomb_v_type2,...
            uncomb_v_type3, combined_u_total, combined_v_total] = deal([]); 
    % uncombined_u(1,:) = type 2 index
    % uncombined_u(2,:) = type 3 index
    for i = 0:num_blocks-1
        uncomb_u_type2 = [uncomb_u_type2 i*N+u_type2];
        uncomb_u_type3 = [uncomb_u_type3 i*N+u_type3];
        uncomb_v_type2 = [uncomb_v_type2 i*N+v_type2];
        uncomb_v_type3 = [uncomb_v_type3 i*N+v_type3];
    end

    m = 1; %superblock size

    for t = 1:n_recursions
        t
        combined_idx = [];
        uncomb_u_type2
        uncomb_u_type3
        uncomb_v_type2
        uncomb_v_type3
        if mod(t,2) == 1
           %first recursion, combine U's 
           
           for i = 1:2*m:num_blocks
               i
               type2_range = (i-1)*num_u_idx+1:(i+m-1)*num_u_idx
               type3_range = (i+m-1)*num_u_idx+1:(i+2*m-1)*num_u_idx
               
               type2_idx = uncomb_u_type2((i-1)*num_u_idx+1:(i+m-1)*num_u_idx)
               type3_idx = uncomb_u_type3((i+m-1)*num_u_idx+1:(i+2*m-1)*num_u_idx)
               
               u(type2_idx) = mod(u(type2_idx) + u(type3_idx), 2);
               % keeps track of combined indices
               combined_idx = [combined_idx [(i-1)*num_u_idx+1:(i+m-1)*num_u_idx; (i+m-1)*num_u_idx+1:(i+2*m-1)*num_u_idx]];
               
           end
           m = 2*m;
           uncomb_u_type2(combined_idx(1,:)) = [];
           uncomb_u_type3(combined_idx(2,:)) = [];
           
           combined_u_total = [combined_u_total combined_idx]; 

        else 
            %second recursion, combine V's 
            for i = 1:2*m:num_blocks
                type2_idx = uncomb_v_type2((i-1)*num_v_idx+1:(i+m-1)*num_v_idx);
                type3_idx = uncomb_v_type3((i+m-1)*num_v_idx+1:(i+2*m-1)*num_v_idx);

                v(type2_idx) = mod(v(type2_idx) + v(type3_idx), 2);

                combined_idx = [combined_idx [(i-1)*num_v_idx+1:(i+m-1)*num_v_idx; (i+m-1)*num_v_idx+1:(i+2*m-1)*num_v_idx]];
               % no longer incompatible after storing
                
            end
            
            uncomb_v_type2(combined_idx(1,:)) = [];
            uncomb_v_type3(combined_idx(2,:)) = [];

            combined_v_total = [combined_v_total combined_idx]; 
           
        end
        
        num_blocks = num_blocks / 2;
                        
    end
        
end

function [idx1, idx2] = equal_idx_lengths(idx1, idx2) 
    if length(idx1) > length(idx2) 
        idx1 = idx1(1:length(idx2));
    else 
        idx2 = idx2(1:length(idx1));
    end 
end

%N - block length


