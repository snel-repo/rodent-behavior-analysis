function [y] = calc_stdev(a, thr, u)

std_dev = 0.5;
p = a(1);
us = u / 5;
s = std_dev;

for i = 1:numel(a)
    s = (1-us) * s + us*abs(a(i) - p);
     p = (1-u) * p + u*a(i);
    if abs(p -a(i)) < thr * s
        p = (1-u) * p + u*a(i);
    end
    y(i) = s;
end
    