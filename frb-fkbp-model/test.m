sbioloadproject('frb-fkbp-hrp-model.sbproj');
for i = 1:size(m1.species,1)
    vpa(m1.species(i).InitialAmount, 32)
    m1.species(i).InitialAmount
end

global mex;
mex = m1;