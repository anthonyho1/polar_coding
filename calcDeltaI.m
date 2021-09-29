function dI = calcDeltaI(a, b, a_p, b_p) 
    a_plus = a + a_p;
    b_plus = b + b_p;
    
    dI = capacity(a,b) + capacity(a_p,b_p) - capacity(a_plus, b_plus);
end 

function C = capacity(a,b)
    if (a ~= 0) && (b ~= 0)
        C = -(a+b) * log2((a+b)/2) + a * log2(a) + b * log2(b);
    elseif (a == 0) && (b ~= 0)
        C = b;
    elseif (a ~= 0) && (b == 0)
        C = a;
    else
        C = 0;
    end
end