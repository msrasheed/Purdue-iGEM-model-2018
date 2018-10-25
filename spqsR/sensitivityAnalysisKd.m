function sensitivityAnalysisKd()

y0 = [44e-6 44e-6 44e-6 0 0 0 3.5662e-4 0];
names = ["pqsR1", "pqsR2", "far", "pqFar", "pq2Far", "pqFarpq", "TMB", "blue"];
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-13);
vary = [-7:7];
%vary = 0:.2:5;


tcheck = 60;
tspan = [0 tcheck];
far = 44e-6;

kd1A =  2.6e-5;
kd2A = 2.0e-10;
kd3A = 1.0e-13;
kd4A = 1.2e-8;
kdAv = 6.5e-6;
%[t,y] = ode15s(@rxnODE, tspan, y0, opts);

global kd1;
kd1 =  kd1A;
global kd2;
kd2 = kd2A;
global kd3;
kd3 = kd3A;
global kd4;
kd4 = kd4A;

% [t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
% compKd = y(size(y,1),8);
compTime = solveReactionTimeKd(tspan, y0, opts);

SKd1 = ones(1,size(vary,2));
for i = 1:size(vary,2)
    kd1 = kd1A*10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %SKd(i) = (y(size(y,1),8)/compKd)/(kd/kds);
    
    time = solveReactionTimeKd(tspan, y0, opts);
    %SKd(i) = ((time-compTime)/compTime)/((kd-kds)/kds);
    %SKd(i) = (time - compTime)/compTime;
    SKd1(i) = log10(time);
    
%     SKd(i) = (time/compTime)/(kd/kds);
%     if time < compTime
%         SKd(i) = SKd(i) * -1;
%     end
end
kd1 = kd1A;

SKd2 = ones(1,size(vary,2));
for i = 1:size(vary,2)
    kd2 = kd2A * 10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %SProtConc(i) = (y(size(y,1),8)/compKd)/(y0(1)/protConc);
    
    time = solveReactionTimeKd(tspan, y0, opts);
    %SProtConc(i) = ((time-compTime)/compTime)/((y0(1)-protConc)/protConc);
    %SProtConc(i) = (time - compTime)/compTime;
    SKd2(i) = log10(time);
    
%     SProtConc(i) = (time/compTime)/(y0(1)/protConc);
%     if time < compTime
%         SProtConc(i) = SProtConc(i) * -1;
%     end
end
kd2 = kd2A;

SKd3 = ones(1,size(vary,2));
for i = 1:size(vary,2)
    kd3 = kd3A * 10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %Skcat(i) = (y(size(y,1),8)/compKd)/(k_catG/k_cat);
    
    time = solveReactionTimeKd(tspan, y0, opts);
    %Skcat(i) = ((time-compTime)/compTime)/((k_catG-k_cat)/k_cat);
    %Skcat(i) = (time-compTime)/compTime;
    SKd3(i) = log10(time);
    
%     Skcat(i) = (time/compTime)/(k_catG/k_cat);
%     if time < compTime
%         Skcat(i) = Skcat(i) * -1;
%     end
end
kd3 = kd3A;

SKd4 = ones(1,size(vary,2));
for i = 1:size(vary,2)
    kd4 = kd4A * 10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %Skm(i) = (y(size(y,1),8)/compKd)/(k_mG/k_m);
    
    time = solveReactionTimeKd(tspan, y0, opts);
    %Skm(i) = ((time-compTime)/compTime)/((k_mG-k_m)/k_m);
    %Skm(i) = (time-compTime)/compTime;
    SKd4(i) = log10(time);
    
%     Skm(i) = (time/compTime)/(k_mG/k_m);
%     if time < compTime
%         Skm(i) = Skm(i) * -1;
%     end
end
kd4 = kd4A;

SKdA = ones(1,size(vary,2));
for i = 1:size(vary,2)
    kd1 = kdAv * 10^vary(i);
    kd2 = kd1;
    kd3 = kd1;
    kd4 = kd1;
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %Skm(i) = (y(size(y,1),8)/compKd)/(k_mG/k_m);
    
    time = solveReactionTimeKd(tspan, y0, opts);
    %Skm(i) = ((time-compTime)/compTime)/((k_mG-k_m)/k_m);
    %Skm(i) = (time-compTime)/compTime;
    SKdA(i) = log10(time);
    
%     Skm(i) = (time/compTime)/(k_mG/k_m);
%     if time < compTime
%         Skm(i) = Skm(i) * -1;
%     end
end
kd1 = kd1A;
kd2 = kd2A;
kd3 = kd3A;
kd4 = kd4A;

subplot(2,2,1);
plot(vary, SKd1);
title('kd1');
ylabel('log(time)');
xlabel('initial k_d * 10^x');

subplot(2,2,2);
plot(vary, SKd2);
title('kd2');
ylabel('log(time)');
xlabel('initial k_d * 10^x');

subplot(2,2,3);
plot(vary, SKd3);
title('kd3');
ylabel('log(time)');
xlabel('initial k_d * 10^x');

subplot(2,2,4);
plot(vary, SKd4);
title('kd4');
ylabel('log(time)');
xlabel('initial k_d * 10^x');

suptitle("Sensitivity Analysis");

figure;
plot(vary, SKdA);
title('kd_{avg}');
ylabel('log(time)');
xlabel('initial k_d * 10^x');

end