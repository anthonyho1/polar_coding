function y = get_y_intervals(sigma, g, lambda)
    y = zeros(length(lambda) - 1, 2);
    for i = 1 : length(lambda) - 1
        y(i, 1) = solveLR_y(sigma, g, lambda(i));
        y(i, 2) = solveLR_y(sigma, g, lambda(i+1));
    end
    y(1,1) = 0;
    y(end,2) = realmax;
    
end