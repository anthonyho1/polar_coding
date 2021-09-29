function Q = interference_channel_to_dmc(y_intervals, theta, sigma, g, mu);
    % 1 < lambda < theta, in this case theta = lambda as calculated beforee 
    Q = zeros(2, 2*mu); % called Q in paper
    % Q' : X -> Z',  Z' = {z_1, zhat_1, z_2, zhat_2, ... , z_mu, zhat_mu}
    % z_i : 2i-1, zhat_i : 2i
    for i = 1 : mu
        y_min = y_intervals(i, 1);
        y_max = y_intervals(i, 2);
        % distribution of normal rv N(0,sigma^2) + uniform rv {-g, +g}
        % f_z(z|0) = (1/2) 1/(sqrt(2pi*sigma^2) exp((z-g-1)/sigma)^2 + 
        %            (1/2) 1/(sqrt(2pi*sigma^2) exp((z+g-1)/sigma)^2
        
        p0_upper = 1/2 * normcdf(y_max, 1+g, sigma) + 1/2 * normcdf(y_max, 1-g, sigma);
        p0_lower = 1/2 * normcdf(y_min, 1+g, sigma) + 1/2 * normcdf(y_min, 1-g, sigma);
        p0 = abs(p0_upper - p0_lower);
        
        % f_z(z|1) = (1/2) 1/(sqrt(2pi*sigma^2) exp((z-g+1)/sigma)^2 + 
        %            (1/2) 1/(sqrt(2pi*sigma^2) exp((z+g+1)/sigma)^2
        
        p1_upper = 1/2 * normcdf(y_max, -1+g, sigma) + 1/2 * normcdf(y_max, -1-g, sigma);
        p1_lower = 1/2 * normcdf(y_min, -1+g, sigma) + 1/2 * normcdf(y_min, -1-g, sigma);
        p1 = abs(p1_upper - p1_lower);
        
        pi_i = p0 + p1; % eqn (42)
        
        if i < mu
            z0 = (theta(i + 1) * pi_i)/(1 + theta(i + 1)); % eqn (43), z=z_i, theta != inf
            z1 = pi_i/(1 + theta(i + 1)); %  z=zhat_i, theta != inf
            Q(1, 2*i - 1) = z0; % Q'(z_i)
            Q(1, 2*i) = z1;     % Q'(zhat_i)
            
            Q(2, 2*i - 1) = z1; % eqn (44), Q'(z_i|1) = Q'(zhat_i|0) 
            Q(2, 2*i) = z0;     % Q'(zhat_i|1) = Q'(z_i|0) 

        else
            Q(1, 2*i - 1) = pi_i; % eqn (43), theta == inf
            Q(2, 2*i - 1) = 0;
            Q(1, 2*i) = 0;
            Q(2, 2*i) = pi_i;
        end
    end
end