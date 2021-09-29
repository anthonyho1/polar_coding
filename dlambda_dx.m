function dx = dlambda_dx(y, sigma, g, lambda)
    dy1 = -(y-g-1) * exp(-(y-g-1)^2/(2*sigma^2)) -  ...
           (y+g-1) * exp(-(y+g-1)^2/(2*sigma^2));
      
    dy2 = (y-g+1) * exp(-(y-g+1)^2/(2*sigma^2)) +  ...
          (y+g+1) * exp(-(y+g+1)^2/(2*sigma^2)); 
      
    dx = 1/sigma^2 * (lambda * dy2 + dy1); 
end