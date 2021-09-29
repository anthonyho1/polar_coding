function W = get_AWGN_transition_probability(sigma, v)
alpha = get_Clambda_zero_points(v)
y = get_y_interval(sigma, alpha)
W = upgrading_transform_AWGN_to_DMC(y, alpha, sigma, v);
end

function W = upgrading_transform_AWGN_to_DMC(y, theta, sigma, v)
W = zeros(2, 2 * v);
for i = 1 : v
    if i < v
        y_min = y(i, 1);
        y_max = y(i, 2);
        p0 = normcdf(y_max, 1, sigma) - normcdf(y_min, 1, sigma);
        p1 = normcdf(y_max, -1, sigma) - normcdf(y_min, -1, sigma);
        pi_i = p0 + p1;
        z0 = (theta(i + 1) * pi_i)/(1 + theta(i + 1));
        z1 = pi_i/(1 + theta(i + 1));
        W(1, 2*i - 1) = z0;
        W(2, 2*i - 1) = z1;
        W(1, 2*i) = z1;
        W(2, 2*i) = z0;
    else
        y_min = y(i, 1);
        y_max = y(i, 2);
        p0 = normcdf(y_max, 1, sigma) - normcdf(y_min, 1, sigma);
        p1 = normcdf(y_max, -1, sigma) - normcdf(y_min, -1, sigma);
        pi_i = p0 + p1;
        W(1, 2*i - 1) = pi_i;
        W(2, 2*i - 1) = 0;
        W(1, 2*i) = 0;
        W(2, 2*i) = pi_i;
    end
end
end
function alpha = get_Clambda_zero_points(v)
alpha = zeros(v + 1, 1);
alpha(1) = 1;
alpha(v + 1) = realmax;
%above two values are obtained by simple calculations and avoid numerical
%problems
%Newton descend method
epsilon = 1e-6;%tolerance error
for i = 2 : v
    beta = (i - 1)/v;
    x0 = 0;
    x1 = 1.5;%initial point, the zero point of d^2C(lambda)/x^2
    while(abs(x0 - x1) > epsilon)
        x0 = x1;
        x1 = x0 - (Clambda(x0) - beta)/dClambdadx(x0);
    end
    alpha(i) = x1;
end

end
function z = dClambdadx(lambda)
z = log2(lambda)./(1 + lambda).^2;
end

function z = Clambda(lambda)
z = 1 - lambda./(1 + lambda).*log2(1 + 1./lambda) - 1./(1 + lambda).*log2(1 + lambda);
end

function y = get_y_interval(sigma, alpha)
    y = zeros(size(alpha, 1) - 1, 2);
    for i = 1 : size(alpha, 1) - 1
        y(i, 1) = sigma^2/2*log(alpha(i));
        y(i, 2) = sigma^2/2*log(alpha(i + 1));
    end
end
