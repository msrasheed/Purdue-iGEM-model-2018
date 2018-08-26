function splitPrior() 
prior = csvread('prior2.csv');
stDevs = [.3 1.3 .3];
mus = [-13.1 -9 -5.5];
peaks = [.025 .20 .137];
x = [-14:.1:-4];
y = ones(size(x,2), size(mus,2));
for i = 1:size(mus,2)
    stDev = stDevs(i);
    mu = mus(i);
    y(:,i) = 1/sqrt(2*pi*stDev^2)*exp(-1*((x-mu).^2)/(2*stDev^2));
%     y(:,i) = y(:,i).*peaks(i)./max(y(:,i));
end
plot(prior(:,1),prior(:,2));
hold on;
plot(x, y);
hold off;
grid on;
end