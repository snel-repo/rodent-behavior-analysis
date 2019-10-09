function [filt, dev] = twoSampleLP(in, u)
p = in(1);
us = u / 5;
s = 4;

for i = 1:numel(in)
    s = (1-us) * s + us*abs(in(i) - p);
        p = (1-u) * p + u*in(i);
    
    filt(i) = p;
    dev(i) = s;
end
    