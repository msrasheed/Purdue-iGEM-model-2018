function bayesianExplanation() 
stds = [1.5 .75];
mus = [7 3];




x = [0:.1:10]';
y = ones(size(x,1),size(mus,2));
for i = 1:size(mus,2)
    mu = mus(i);
    stDev = stds(i);
    y(:,i) = 1/sqrt(2*pi*stDev^2)*exp(-1*((x-mu).^2)/(2*stDev^2));
end

y2 = y(:,1) .* y(:,2) ./ .015;
y = [y y2];

plot(x,y);
xlabel('Param');
ylabel('Probability');
title('Prior and Likelihood');
end