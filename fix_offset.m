%fix_offset
maxS = 500;
maxV = -4;
dt = 2e-3;
runtime = 100000;
offset = zeros(1,runtime);
mean_pos = zeros(1,1000);
offset(1) = mean(rawspeed(:,2)); %initial guess is the current mean of the voltage for speed
plotSpeed = ((rawspeed(:,2) / maxV) * maxS);
mean_pos(1) = mean(360*cumsum(plotSpeed*(dt/(60))));


for i = 2:runtime
    mean_pos(i) = mean(360*cumsum(plotSpeed*(dt/(60))+ offset(i-1)));
    if mean_pos(i) > 0
        offset(i) = offset(i-1) + .0001*offset(i-1);
    else
        offset(i) = offset(i-1) - .0001*offset(i-1);
    end
end