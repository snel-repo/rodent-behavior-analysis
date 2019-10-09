function [] = ledTouchPlot(velStoreFull, posStoreFull, session)

figure
tempVel = velStoreFull{session};
tempPos = posStoreFull{session};
subplot(2,1,1)

for j = 1:length(tempPos)
    plot(tempPos{j} * 2000 / (65536), 'color', 'b')
    hold on
end
    title('Position for LED Touch Association')
    xlabel('Time')
    ylabel('Angle (deg)')
subplot(2,1,2)
for j = 1:length(tempVel)
plot(tempVel{j} * 2000 / (65536), 'color', 'b')
hold on
end