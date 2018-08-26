function frbFkbpParameterSensitivity(m1)
% sbioloadproject('frb-fkbp-hrp-model.sbproj');
% sbioaccelerate(m1);
exps = [-34:.1:-3];
errs = ones(size(exps, 2), 5);
for i = 0:4
    for x = 1:size(exps, 2)
        errs(x, i+1) = frbFkbpSimulatorMK2(exp(exps(x)), m1, i);
        %errs(x) = abs((errs(x) - 1.5763e-4) / 7.7535e-5);
    end
end
plot(exps, errs);
xlabel('ln(K_d)');
ylabel('SSE');
title('Dissociation Constant Sensitivity Analysis');
legend('rap = .166','rap =   .25','rap = .5','rap = .75','rap = 1', 'Location', 'north');
grid on;
end