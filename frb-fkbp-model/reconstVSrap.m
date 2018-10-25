function reconstVSrap() 
sbioloadproject('frb-fkbp-titration.sbproj');
rapVals = [[0:.01:1] [1:.1:5]];
reconstVals = size(rapVals, 2);
for i = 1:size(rapVals, 2)
    m1.Species(3).InitialAmount = rapVals(i);
    sim = sbiosimulate(m1);
    reconstVals(i) = sim.Data(end,7);
end
plot(rapVals, reconstVals, '-');
xlabel("biomarker");
ylabel("[HRP_{reconst}]");
title("Protein Complex vs [Rapamycin]");
end