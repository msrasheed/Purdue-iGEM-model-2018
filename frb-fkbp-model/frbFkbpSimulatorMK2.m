function SSE = frbFkbpSimulatorMK2(paramArray, m1)
%paramArray = cell2mat(paramArray);
%sbioloadproject('frb-fkbp-hrp-model.sbproj');
numReacts = m1.reactions.length - 4;
index = 1;
for react = 1:numReacts
    reaction = m1.reactions(react);
    numParams = reaction.kineticLaw.parameters.length;
    for paramInd = 1:numParams
        param = reaction.kineticLaw.parameters(paramInd);
        if strcmp(param.Name, 'kf')
            param.Value = 1;
        else
            param.Value = paramArray(index);
            index = index + 1;
        end
    end
end
% for react = 1:m1.reactions.length
%     m1.reactions(react).kineticLaw.parameters
% end
sim = sbiosimulate(m1);
blueCompInd = find(sim.DataNames == "blueComp");
data = sim.Data(:,blueCompInd);
time = sim.Time;
blue3 = .1164 .* time .^ 3.482;
for i = 1:size(blue3,1)
    if blue3(i) > 1
        blue3(i) = 1;
    end
end
SSE = sum((data - blue3).^2);
end