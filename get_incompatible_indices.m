function [type2_idx, type3_idx] = get_incompatible_indices(frozen_idx1, frozen_idx2)
    type2_idx = setdiff(frozen_idx1, frozen_idx2); % good in channel 1, bad for channel 2
    type3_idx = setdiff(frozen_idx2, frozen_idx1); % bad in channel 1, good for channel 2
end