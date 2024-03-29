function optimalProteinConc() 
y0 = [44e-6 44e-6 44e-6 0 0 0 3.5662e-4 0];
names = ["pqsR1", "pqsR2", "far", "pqFar", "pq2Far", "pqFarpq", "TMB", "blue"];
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-13);
tspan = [0 120];



concs = -11:.1:-1;
bioConcs = [44e-6 .5e-6];
rxntimes = ones(1, size(concs,2)) .* -1;
diffTime = ones(1,size(concs,2)).* -1;
for i = 1:size(concs, 2)
    y0(1) = exp(concs(i));
    y0(2) = exp(concs(i));
    y0(3) = bioConcs(1);
    tspan(2) = 120;
    while rxntimes(i) == -1
        tspan(2) = tspan(2) + 60;
        [t,y] = ode15s(@rxnODE, tspan, y0, opts);
        rxntimes(i) = reactionTime(t, y0(7), y(:,8));
        if tspan(2) >= 1200
            rxntimes(i) = tspan(2);
        end
    end
    y0(3) = bioConcs(2);
    tspan(2) = 120;
    while diffTime(i) == -1
        tspan(2) = tspan(2) + 60;
        [t,y] = ode15s(@rxnODE, tspan, y0, opts);
        diffTime(i) = reactionTime(t, y0(7), y(:,8));
        if tspan(2) >= 3600
            diffTime(i) = tspan(2);
        end
    end
    diffTime(i) = diffTime(i) - rxntimes(i);
end

figure;
rxntimes = rxntimes ./ 60;
diffTime = diffTime ./ 60;
plot(rxntimes, diffTime);
xlabel('rxntimes (min)');
ylabel('diffTime (min)');
for i = 1:10:size(concs,2)
    text(rxntimes(i), diffTime(i), "\leftarrow "+num2str(concs(i)));
end
end