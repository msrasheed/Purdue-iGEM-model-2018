function getSSEs()
sbioloadproject('frb-fkbp-hrp-model.sbproj');
amts = [.166 .25 .5 .75 1];
blues = [];
times = [];
SSE = amts;

for x = 1:size(amts, 2)
    m1.species(3).initialAmount = amts(x);
    sim = sbiosimulate(m1);
    blue = sim.Data(:,9);
    inds = find(blue >= 1);
    blue = blue(2:inds(1));
    time = sim.Time(2:inds(1));
    f = fit(time, blue, 'power1');
    a = f.a
    b = f.b
    checkBlue = a .* time .^ b;
    SSE(x) = sum((blue-checkBlue).^2);
end

SSE
mean(SSE)
std(SSE)
end
