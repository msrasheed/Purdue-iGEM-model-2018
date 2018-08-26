function runODE()
y0 = [44e-6 44e-6 44e-6 0 0 0 3.5662e-4 0];
names = ["pqsR1", "pqsR2", "far", "pqFar", "pq2Far", "pqFarpq", "TMB", "blue"];
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-13);
tspan = [0 180];
%concs = -11:2:-1;
concs = log([44e-6 .5e-6]);
plots = 1:8; %[3 4 5 6];
% figure('Position', [0,0,800,600]);
% hold on;
diffOMbio = ones(1, size(concs,2));
diffOMTMB = ones(1,size(concs,2));
rxnTimes = ones(1, size(concs,2));
for i = 1:size(concs,2)
    figure('Position', [((i-1)*100),50,800,600]);
    for j = 3
        y0(j) = exp(concs(i));
        y0(1) = exp(-7);
        y0(2) = exp(-7);
    end
    [t,y] = ode15s(@rxnODE, tspan, y0, opts);
    %plot(t,y(:,8));
    plot(t,y(:, plots));
    title(num2str(exp(concs(i))));
    legend(names(plots), 'Location', 'eastoutside');
    
    diffOMTMB(i) = log10(y0(1)) - log10(y0(7));
    diffOMbio(i) = log10(y0(1)) - log10(y0(3));
    rxnTimes(i) = reactionTime(t, y0(7), y(:,8));
    
    reactionTime(t, y0(3), y(:,8))
end

% figure;
% plot(diffOMbio, rxnTimes);
% title('Time vs. diff OM bio');
% figure;
% plot(diffOMTMB, rxnTimes);
% title('Time vs. diff OM TMB');

% hold off;
% expConcs = exp(concs);
% strExpConcs = "";
% for j = 1:size(expConcs,2)
%     strExpConcs = [strExpConcs num2str(expConcs(j))];
% end
% strExpConcs = strExpConcs(2:size(strExpConcs,2));
%legend(strExpConcs, 'Location', 'eastoutside');
%[rel,abs] = analyzeRelAbsTol(y)

end
