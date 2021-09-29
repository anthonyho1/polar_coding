function out = f(r1,r2)
    out = sign(r1) .* sign(r2) .* min(abs(r1), abs(r2));
end
