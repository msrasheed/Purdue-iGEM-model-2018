function sensitivityAnalysis(kds, protConc)

y0 = [44e-6 44e-6 44e-6 0 0 0 3.5662e-4 0];
names = ["pqsR1", "pqsR2", "far", "pqFar", "pq2Far", "pqFarpq", "TMB", "blue"];
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-13);
vary = [-7:.2:-.2 .2:.2:7];
%vary = 0:.2:5;


tcheck = 60;
tspan = [0 tcheck];
far = 44e-6;
k_cat = 435;
k_m = 9.0e-5;
%[t,y] = ode15s(@rxnODE, tspan, y0, opts);

global kd;
kd = kds;
global k_catG;
k_catG = k_cat;
global k_mG;
k_mG = k_m;

% [t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
% compKd = y(size(y,1),8);
compTime = solveReactionTime(tspan, y0, opts);

SKd = ones(1,size(vary,2));
for i = 1:size(vary,2)
    kd = kds*10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %SKd(i) = (y(size(y,1),8)/compKd)/(kd/kds);
    
    time = solveReactionTime(tspan, y0, opts);
    %SKd(i) = ((time-compTime)/compTime)/((kd-kds)/kds);
    %SKd(i) = (time - compTime)/compTime;
    SKd(i) = log10(time);
    
%     SKd(i) = (time/compTime)/(kd/kds);
%     if time < compTime
%         SKd(i) = SKd(i) * -1;
%     end
end
kd = kds;

SProtConc = ones(1,size(vary,2));
for i = 1:size(vary,2)
    y0(1) = protConc * 10^vary(i);
    y0(2) = protConc * 10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %SProtConc(i) = (y(size(y,1),8)/compKd)/(y0(1)/protConc);
    
    time = solveReactionTime(tspan, y0, opts);
    %SProtConc(i) = ((time-compTime)/compTime)/((y0(1)-protConc)/protConc);
    %SProtConc(i) = (time - compTime)/compTime;
    SProtConc(i) = log10(time);
    
%     SProtConc(i) = (time/compTime)/(y0(1)/protConc);
%     if time < compTime
%         SProtConc(i) = SProtConc(i) * -1;
%     end
end
y(1) = protConc;
y(2) = protConc;

Skcat = ones(1,size(vary,2));
for i = 1:size(vary,2)
    k_catG = k_cat * 10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %Skcat(i) = (y(size(y,1),8)/compKd)/(k_catG/k_cat);
    
    time = solveReactionTime(tspan, y0, opts);
    %Skcat(i) = ((time-compTime)/compTime)/((k_catG-k_cat)/k_cat);
    %Skcat(i) = (time-compTime)/compTime;
    Skcat(i) = log10(time);
    
%     Skcat(i) = (time/compTime)/(k_catG/k_cat);
%     if time < compTime
%         Skcat(i) = Skcat(i) * -1;
%     end
end
k_catG = k_cat;

Skm = ones(1,size(vary,2));
for i = 1:size(vary,2)
    k_mG = k_m * 10^vary(i);
    %[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    %Skm(i) = (y(size(y,1),8)/compKd)/(k_mG/k_m);
    
    time = solveReactionTime(tspan, y0, opts);
    %Skm(i) = ((time-compTime)/compTime)/((k_mG-k_m)/k_m);
    %Skm(i) = (time-compTime)/compTime;
    Skm(i) = log10(time);
    
%     Skm(i) = (time/compTime)/(k_mG/k_m);
%     if time < compTime
%         Skm(i) = Skm(i) * -1;
%     end
end
k_mG = k_m;

subplot(2,2,1);
plot(vary, SKd);
title('kd');
ylabel('log(time)');
xlabel('initial k_d * 10^x');

subplot(2,2,2);
plot(vary, SProtConc);
title('ProtConc');
ylabel('log(time)');
xlabel('initial [Prot] * 10^x');

subplot(2,2,3);
plot(vary, Skcat);
title('kcat');
ylabel('log(time)');
xlabel('initial k_{cat} * 10^x');

subplot(2,2,4);
plot(vary, Skm);
title('km');
ylabel('log(time)');
xlabel('initial k_m * 10^x');

suptitle("Sensitivity Analysis");

end











