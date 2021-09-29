function L = init_LLRs(y, noise_var)
    L = 2 .* y ./ noise_var;
end