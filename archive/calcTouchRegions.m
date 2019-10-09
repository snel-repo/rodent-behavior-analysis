function [areaRegions] = calcTouchRegions(diffTouch)
regionNum = 1;
flagStartTouch = 0;
for i = 1:length(diffTouch)
    if diffTouch(i) == 1
        areaRegions(regionNum, 1) = i;
        flagStartTouch = 1;
    elseif diffTouch(i) == -1
        areaRegions(regionNum, 2) = i;
        flagStartTouch =0;
        regionNum = regionNum + 1;
    end
    
    if i == length(diffTouch) && flagStartTouch == 1;
        areaRegions(regionNum, 2) = i;
        regionNum = regionNum + 1;
    end
    
end


        