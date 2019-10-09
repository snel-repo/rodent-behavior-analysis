function [y, y2, y3] = calc_baseline(a, thr, u)

std_dev = 4;

p = a(1);
us = u / 5;
s = std_dev;

for i = 1:numel(a)
    s = (1-us) * s + us*abs(a(i) - p);
    filtDiff = p - a(i);
    if (filtDiff > 0) && (filtDiff < thr * s)
        p = (1-u) * p + u*a(i);
    elseif (filtDiff <= 0) && (filtDiff < (-s / 100000))
        p = (1-u) * p + u*a(i);
    end
        %     if ((p -a(i)) < thr * s) 
%          p = (1-u) * p + u*a(i);
%     end
    y(i) = p;
    y2(i) = s;
    y3(i) = filtDiff;
end
    