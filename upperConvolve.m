function Q = upperConvolve(P) 
    mu = length(P);
    Q = zeros(2,mu*(mu+1)/2);
    idx = 0;
    for i = 1:mu
       idx = idx + 1;
       Q(1,idx) = (P(1,i)^2 + P(2,i)^2) / 2;
       Q(2,idx) = P(1,i) * P(2,i);
       
       for j = i+1:mu
         Q(1,idx) = P(1,i) * P(1,j) + P(2,i) * P(2,j);
         Q(2,idx) = P(1,i) * P(2,j) + P(2,i) * P(1,j);
         %swap
         if (Q(1,idx) < Q(2,idx)) 
             tmp = Q(2,idx);
             Q(2,idx) = Q(1,idx);
             Q(1,idx) = tmp;
         end
             
    end

end