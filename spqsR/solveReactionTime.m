function time = solveReactionTime(tspan, y0, opts)
rxntime = -1;





while rxntime == -1
    tspan(2) = tspan(2) * 2;
    [t,y] = ode15s(@rxnODESenAnyl, tspan, y0, opts);
    rxntime = reactionTime(t, y0(7), y(:,8));
%     if tspan(2) >= 1200
%         rxntime = tspan(2);
%     end
end
time = rxntime;
end