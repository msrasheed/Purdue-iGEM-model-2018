function reconstVSrap() 
sbioloadproject('frb-fkbp-hrp-model.sbproj');
rapVals = [[0:.1:1] [1:.1:5]];
reconstVals = size(rapVals, 2);
for i = 1:size(rapVals, 2)
    m1.Species(3).InitialAmount = rapVals(i);
    sim = sbiosimulate(m1);
    reconstVals(i) = sim.Data(end,6);
end
plot(rapVals, reconstVals);
xlabel("Rapamycin");
ylabel("FKBP-FRB Complex");
title("Protein Complex vs [Rapamycin]");
end