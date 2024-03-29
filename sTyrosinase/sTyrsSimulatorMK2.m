function SSE = sTyrsSimulatorMK2(paramArray, m1, data)
%paramArray = cell2mat(paramArray);
%sbioloadproject('frb-fkbp-hrp-model.sbproj');
numReacts = m1.reactions.length - 2;
index = 1;
for react = 1:numReacts
    reaction = m1.reactions(react);
    numParams = reaction.kineticLaw.parameters.length;
    for paramInd = 1:numParams
        param = reaction.kineticLaw.parameters(paramInd);
        if strcmp(param.Name, 'kf')
            param.Value = 1;
        else
            param.Value = paramArray; %(index);
            index = index + 1;
        end
    end
end
% for react = 1:m1.reactions.length
%     m1.reactions(react).kineticLaw.parameters
% end

a = [.1164 .1651 .2846 .3734 .4385];
b = [3.482 3.473 3.409 3.330 3.246];
amt = [.166 .25 .5 .75 1];
data = data + 1;

a = a(data);
b = b(data);
m1.species(3).InitialAmount = amt(data);

sim = sbiosimulate(m1);
blueCompInd = find(sim.DataNames == "blueComp");
data = sim.Data(:,blueCompInd);
time = sim.Time;
        
blue3 = a .* time .^ b;
for i = 1:size(blue3,1)
    if blue3(i) > 1
        blue3(i) = 1;
    end
end
SSE = sum((data - blue3).^2);
end