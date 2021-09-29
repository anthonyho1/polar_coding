u = zeros(1,128);
u(1:2:end) = 1;
v = zeros(1,128);
v(1:2:end) = 1;

frozen1 = [1 2 4 6];
frozen2 = [1 3 5 7];

[type2_idx, type3_idx] = get_incompatible_indices(frozen1, frozen2)

recursions = 4
N = 8

[u, v, combined_u, combined_v] = align_incompatible(type2_idx, type3_idx, ...
                                            type2_idx, type3_idx, u, v, recursions, N)   