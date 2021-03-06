type2 = [1 3 5 9 10 15];
type3 = [2 4 6 7 8 16];
blocks = 32;
N = 16;
recursions = 3;
total_len = blocks * N; 


[incomps, dec_ords, enc_ords] = get_aligned_structure(type2, type3, blocks, N, recursions)

[dec_order, enc_order, combined_idx] = get_full_decoding_order(dec_ords, incomps, blocks, N);
combined_idx

%dec
for i = 1:recursions 
    if blocks == 2
        N=2*N;
        blocks = blocks/2;
    else 
        N = 4*N;
        blocks = blocks/4;
    end
    order = dec_ords(i,1:N);
    head = 1;
    
    for j = 0:blocks-1
        tail = head+N-1;
        dec_ords(i,head:tail) = order+N*j;
        head = head+N;
    end
    
end

dec_ords;
decorder = 1:512;
for i = 1:size(dec_ords,1)
    decorder = decorder(dec_ords(i,:));
end
dorder = decorder' 

%enc
% blocks = 32;
% N = 16;
% recursions = 3;
% total_len = blocks * N; 
% enc_ords = flip(enc_ords,1);
% 
% for i = 1:recursions 
%     if blocks == 2
%         N=2*N
%         blocks = blocks/2;
%     else 
%         N = 4*N;
%         blocks = blocks/4
%     end
%     order = enc_ords(i,1:N);
%     head = 1
%     
%     for j = 0:blocks-1
%         tail = head+N-1;
%         enc_ords(i,head:tail) = order+N*j;
%         head = head+N;
%     end
%     
% end
% enc_ords = flip(enc_ords,1)
% encorder = 1:512;
% for i = 1:size(enc_ords,1)
%     encorder = encorder(enc_ords(i,:));
% end


    
    
    