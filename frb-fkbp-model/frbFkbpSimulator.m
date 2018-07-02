function [data, time] = frbFkbpSimulator(paramArray, m1)
%paramArray = cell2mat(paramArray);
%sbioloadproject('frb-fkbp-hrp-model.sbproj');
numReacts = m1.reactions.length - 2;
index = 1;
for react = 1:numReacts
    reaction = m1.reactions(react);
    numParams = reaction.kineticLaw.parameters.length;
    for paramInd = 1:numParams
        param = reaction.kineticLaw.parameters(paramInd);
        if strcmp(param.Name, 'kf') && react < 5
            param.Value = 1;
        else
            param.Value = paramArray(index);
            index = index + 1;
        end
    end
end
sim = sbiosimulate(m1);
blueCompInd = find(sim.DataNames == "blueComp");
data = sim.Data(:,blueCompInd);
time = sim.Time;
data = data';
time = time';
end