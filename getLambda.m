function lambda = getLambda(mu)
    lambda = zeros(mu+1,1);
    lambda(1) = 1;
    lambda(end) = realmax;
    
    tol = 1E-6;
    for j = 2 : mu
        x0 = 0;
        x1 = 1.5; % initial guess 
        j_mu = (j-1)/mu;
        while abs(x1 - x0) > tol
               x0 = x1;
               x1 = x0 - (capacity(x0) - j_mu) / dcdx_capacity(x0);
        end 
        lambda(j) = x1;
    end
end

function C =  capacity(lambda)
    C  = 1 - lambda./(lambda+1).*log2(1 + 1./lambda) - 1 ./ (lambda + 1) * log2(1+lambda);
end

%d/dx (C(lambda))
function dCdx =  dcdx_capacity(lambda)
    dCdx  = log2(lambda) ./ (1 + lambda)^2;
end

