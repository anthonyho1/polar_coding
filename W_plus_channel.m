function W_plus = W_plus_channel(W)
    N = size(W, 2);
    W_plus = zeros(2, 2 * N^2);
    for u2 = 0 : 1
        for y1 = 1 : N
            for y2 = 1 : N
                for u1 = 0 : 1
                    W_plus(u2 + 1, 2 * N * (y1 - 1) + 2 * (y2 - 1) + u1 + 1) ...
                        = 0.5 * W(mod(u1 + u2, 2) + 1, y1) * W(u2 + 1, y2);
                end
            end
        end
    end
end

% function W_plus = W_plus_channel(W)
%     N = size(W, 2);
%     W_plus = zeros(2, 2 * N^2); %output alphabet is |Y|^2 x |X|
%     
%     % eqn (6)
%     for u2 = 0 : 1
%         for y1 = 1 : N
%             for y2 = 1 : N
%                 for u1 = 0 : 1
%                     W_plus(u2 + 1, 2 * N * (y1 - 1) + 2 * (y2 - 1) + u1 + 1) ...
%                         = 0.5 * W(mod(u1 + u2, 2) + 1, y1) * W(u2 + 1, y2);
%                 end
%             end
%         end
%     end 
% end