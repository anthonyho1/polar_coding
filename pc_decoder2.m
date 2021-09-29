function [u_hat, h] = pc_decoder2(y,frozen_bits,var)
    N = length(y);
    u_hat(1:N)=0;
    h = zeros(1,N);
    for i=1:N
        if frozen_bits(i)==1;
            u_hat(i)=0;
        else
            h(i) = get_llr(y, u_hat, N, i, var);
            if h(i) >= 1
                u_hat(i) = 0;
            else
                u_hat(i) = 1;
            end
        end
    end

end

function L=get_llr(y, u_hat,N,i,var)
    if N~=1                        
        if mod(i,2)==1              

            u_plus = mod(u_hat(1:2:i-1) + u_hat(2:2:i-1),2);                                                                                                               %i~=1时
            u_odd = u_hat(2:2:i-1);

            llr_1 = get_llr(y(1:N/2), u_plus, N/2, (i+1)/2, var);
            llr_2 = get_llr(y(N/2+1:N), u_odd, N/2, (i+1)/2, var);

            L=f(llr_1, llr_2);

        else                      
            u_plus = mod(u_hat(1:2:i-2) + u_hat(2:2:i-2), 2);
            u_odd = u_hat(2:2:i-2);

            llr_1 = get_llr(y(1:N/2), u_plus, N/2, i/2, var);
            llr_2 = get_llr(y(N/2+1:N), u_odd, N/2, i/2, var);
            
            L=g(llr_1, llr_2, u_hat(i-1));
        end
    else
        L=-2*y/var;

    end
        
    
end