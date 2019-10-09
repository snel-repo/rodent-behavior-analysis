function [baseline, touchOut, diagnostic] =  baselineLP(filt, u, vel)
% Author: Tony Corsten 08/05/2018, tony.corsten93@gmail.com
% Updated: 08/06/2018
% This takes filtered touch data and attempts to accurately determine a
% 'baseline'. This baseline is used to determine touch regions by the eqtn:
% Touch = (Filt - Baseline) < touchThresh (not filt this fcn)
dThresh = -1;
filtThresh = -3;
touch = 0;
dFilt = 0;
dTouch = 0;
dFiltOld = 0;
for i = 1:numel(filt)   
    if i == 1
        p = filt(1);
    else
        dFilt = filt(i) - filt(i - 1); % calculates the rate of change of the filtered data
        dTouch = filt(i) - baseline(i-1); % calculates difference between current filtered value and previous baseline meas.
        if ~touch && (dFilt <  dThresh) && dTouch < filtThresh
            touch = 1;
            p = baseline(i-1);
            diagnostic(i) = 1;
        elseif touch && dFilt > abs(dThresh) && dFiltOld > abs(dThresh)
            touch = 0;
            p = (1-u) * p + u*filt(i);
            diagnostic(i) = 2;
        elseif vel
            p = baseline(i-1);
            diagnostic(i) = 3;
        elseif dTouch > 3 
            p = (1-u) * p + u*filt(i);
            diagnostic(i) = 4;
        elseif dTouch < -5 
            touch = 1;
            p = baseline(i-1);
            diagnostic(i) = 5;
        else
            touch = 0;
            p = (1-u) * p + u*filt(i);
            diagnostic(i) = 6;
        end
    end  
    
 
    baseline(i) = p;
    touchOut(i) = touch;
    dFiltOut(i) = dFilt;
    dTouchOut(i) = dTouch;
    dFiltOld = dFilt;
end
