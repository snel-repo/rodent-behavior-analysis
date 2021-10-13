
close all
clear all

data18 = [2732, 2458, 2183, 1910, 1634];
data16 = [2744, 2470, 2196, 1923, 1650];
data25 = [2628, 2347, 2067, 1787, 1506];

current = [-40, -20, 0, 20, 40]*1e-3;

p18 = polyfit(data18,current,1);
p16 = polyfit(data16,current,1);
p25 = polyfit(data25,current,1);

figure
plot(data18,current,'.-'); hold on
plot(data18, data18*p18(1)+p18(2))

figure
plot(data16,current,'.-'); hold on
plot(data16, data16*p16(1)+p16(2))

figure
plot(data25,current,'.-'); hold on
plot(data25, data25*p25(1)+p25(2))