function y = solveLR_y(sigma,g, lambda)
    y0 = 0.1;
    y1 = 0.5; % initial guess 
    tol = 10^-4;
    while abs(y1 - y0) > tol
           y0 = y1;
           fx = LR_lambda(y0, sigma, g, lambda);
           dfdx = dlambda_dx(y0, sigma, g, lambda);
           y1 = y0 - fx / dfdx;
    end 
    y = y1;
end

function y = LR_lambda(y, sigma, g, lambda)
    y1 = exp(-(y-g-1)^2/(2*sigma^2)) + exp(-(y+g-1)^2/(2*sigma^2));
    
    y2 = exp(-(y-g+1)^2/(2*sigma^2)) + exp(-(y+g+1)^2/(2*sigma^2));
    
    y = y1 - lambda * y2; % y1/y2 = lambda ==> y1 - lambda * y2 = 0 
end

function dx = dlambda_dx(y, sigma, g, lambda)
    dy1 = -(y-g-1) * exp(-(y-g-1)^2/(2*sigma^2)) -  ...
           (y+g-1) * exp(-(y+g-1)^2/(2*sigma^2));
      
    dy2 = (y-g+1) * exp(-(y-g+1)^2/(2*sigma^2)) +  ...
          (y+g+1) * exp(-(y+g+1)^2/(2*sigma^2)); 
      
    dx = 1/sigma^2 * (lambda * dy2 + dy1); 
end