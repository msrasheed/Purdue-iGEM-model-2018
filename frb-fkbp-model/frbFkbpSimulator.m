function [data, time] = frbFkbpSimulator(paramArray)
paramArray = cell2mat(paramArray);
sbioloadproject('frb-fkbp-hrp-model.sbproj');
numReacts = m1.reactions.length;
index = 1;
for react = 1:numReacts
    reaction = m1.reactions(react);
    numParams = reaction.kineticLaw.parameters.length;
    for paramInd = 1:numParams
        param = reaction.kineticLaw.parameters(paramInd);
        param.Value = paramArray(index);
        index = index + 1;
    end
end
sim = sbiosimulate(m1);
blueCompInd = find(sim.DataNames == "blueComp");
data = sim.Data(:,blueCompInd);
time = sim.Time;
data = data';
time = time';
end