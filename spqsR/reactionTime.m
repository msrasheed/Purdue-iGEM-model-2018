function time = reactionTime(t,TMB,blue)
targetConcBlue = TMB;
index = find(blue >= targetConcBlue*.99, 1);






if isempty(index)
    time = -1; %t(length(t));
else
    time = t(index);
end
end