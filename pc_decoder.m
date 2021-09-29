function [u, v] = pc_decoder(y, frozen_bits_array)

    N = length(y);

    if N == 2
        L_u1 = f(y(1), y(2));

        u = zeros(1, 2);
        if frozen_bits_array(1) == 1
            u(1) = 0;
        elseif L_u1 >= 0
            u(1) = 0;
        else
            u(1) = 1;
        end

        L_u2 = g(y(1), y(2), u(1));

        if frozen_bits_array(2) == 1
            u(2) = 0;
        elseif L_u2 >= 0
            u(2) = 0;
        else
            u(2) = 1;
        end
        
        %propagate results of u backwards
        v = zeros(1, 2);
        v(1) = mod(u(1)+u(2), 2);
        v(2) = u(2);

    else

        L_w_even = f(y(1:2:N), y(2:2:N));

        frozen_bits_1 = frozen_bits_array(1:(N/2));

        [u1, v1] = pc_decoder(L_w_even, frozen_bits_1); % upper half 0 : N/2

        L_w_odd = g(y(1:2:N), y(2:2:N), v1);

        frozen_bits_2 = frozen_bits_array((N/2+1):N);

        [u2, v2] = pc_decoder(L_w_odd, frozen_bits_2); % lower half N/2 : N
        u = [u1, u2];

        v = zeros(1, N);
        % propagate forwards, add the upper and lower halves together as 
        % in polar transform
%         for index = 1:(N/2)
%             v(2*index-1) = mod(v1(index)+v2(index),2); 
%             v(2*index) = v2(index);
%         end
        v(1:2:end) = mod(v1+v2,2); 
        v(2:2:end) = v2;

    end

end
