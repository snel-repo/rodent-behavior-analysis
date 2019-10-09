function [areaRegions] = calcActiveRegions(in, ignoreMinSamples, stitchMinSamples)
regionNum = 1;
flagStartTouch = 0;
falseArea = [];
areaRegions = [];
for i = 1:length(in)
    if in(i) == 1
        areaRegions(regionNum, 1) = i;
        flagStartTouch = 1;
    elseif in(i) == -1
        areaRegions(regionNum, 2) = i;
        flagStartTouch =0;
        regionNum = regionNum + 1;
    end
    
    if i == length(in) && flagStartTouch == 1
        areaRegions(regionNum, 2) = i;
        regionNum = regionNum + 1;
    end
end

preStitchRegions = areaRegions;
%stitch together false negatives
i = 1;
if ~isempty(areaRegions)
    while true
        if i == length(areaRegions(:,1))
            break;
        end
        if (areaRegions(i+1, 1) - areaRegions(i, 2)) <= stitchMinSamples
            tmpStart = areaRegions(i,1);
            tmpEnd = areaRegions(i+1,2);
            areaRegions(i,:) = [tmpStart tmpEnd];
            areaRegions(i+1, :) = [];
        else
            i = i + 1;
        end
    end
    preRemovalRegions = areaRegions;
    % remove erroneous hits
    for i = 1:length(areaRegions(:,1))
        if (areaRegions(i,2) - areaRegions(i,1)) <= ignoreMinSamples
            falseArea = [falseArea i];
        end
    end
    areaRegions(falseArea, :) = [];
end


