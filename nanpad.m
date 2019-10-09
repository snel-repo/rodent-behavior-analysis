function [out] =nanpad(in, dataRange, duration, paddata)
outTmp = in(dataRange);
padsize = duration - length(outTmp);
if padsize < 0
    padsize = 0;
end
out = padarray(outTmp, padsize, paddata, 'post');
out = out(1:duration);

