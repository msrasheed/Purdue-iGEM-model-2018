function [data, time] = accelerateTest(paramArray, func)
sim = func(paramArray, 20);
data = sim.Data;
time = sim.Time;
data = data';
time = time';
end