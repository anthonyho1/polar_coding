function y = LR_lambda(y, sigma, g, lambda)
    y1 = exp(-(y-g-1)^2/(2*sigma^2)) + exp(-(y+g-1)^2/(2*sigma^2));
    
    y2 = exp(-(y-g+1)^2/(2*sigma^2)) + exp(-(y+g+1)^2/(2*sigma^2));
    
    y = y1 - lambda * y2; % y1/y2 = lambda ==> y1 - lambda * y2 = 0 
end