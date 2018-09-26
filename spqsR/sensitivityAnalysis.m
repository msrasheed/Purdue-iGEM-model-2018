function sensitivityAnalysis(kds, protConc)

y0 = [44e-6 44e-6 44e-6 0 0 0 3.5662e-4 0];
names = ["pqsR1", "pqsR2", "far", "pqFar", "pq2Far", "pqFarpq", "TMB", "blue"];
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-13);
vary = -10:10;
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

[t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
compKd = y(size(y,1),8);

SKd = ones(1,size(vary,2));
for i = 1:size(vary,2)
    kd = kds*10^vary(i);
    [t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    SKd(i) = (y(size(y,1),8)/compKd)/(kd/kds);
end
kd = kds;

SProtConc = ones(1,size(vary,2));
for i = 1:size(vary,2)
    y0(1) = protConc * 10^vary(i);
    y0(2) = protConc * 10^vary(i);
    [t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    SProtConc(i) = (y(size(y,1),8)/compKd)/(y0(1)/protConc);
end
y(1) = protConc;
y(2) = protConc;

Skcat = ones(1,size(vary,2));
for i = 1:size(vary,2)
    k_catG = k_cat * 10^vary(i);
    [t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    Skcat(i) = (y(size(y,1),8)/compKd)/(k_catG/k_cat);
end
k_catG = k_cat;

Skm = ones(1,size(vary,2));
for i = 1:size(vary,2)
    k_mG = k_m * 10^vary(i);
    [t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    Skm(i) = (y(size(y,1),8)/compKd)/(k_mG/k_m);
end
k_catG = k_cat;

subplot(2,2,1);
plot(vary, SKd);

end











