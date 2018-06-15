function splitProteinModel() 
%variables for reaction 1
tyslConc = 1;
splitTyrsConc = 1;
react1_Km = 1;
react1_kcat = 1;

%variables for reaction 2
TMBConc = 1;
splitHRPConc = 0;
react2_Km = 1;
react2_kcat = 1;
blueSubConc = 0;

timeStep = 1e-3;
time = 0:timeStep:10;
blueSubConcHist = 1:size(time,2);
for i = 1:size(time,2)
    reactRate1 = (splitTyrsConc * react1_kcat) * tyslConc / (react1_Km + tyslConc);
    tyslConc = tyslConc - reactRate1 * timeStep;
    splitHRPConc = splitHRPConc + reactRate1 * timeStep;
    reactRate2 = (splitHRPConc * react2_kcat) * TMBConc / (react2_Km + TMBConc);
    TMBConc = TMBConc - reactRate2 * timeStep;
    blueSubConc = blueSubConc + reactRate2 * timeStep;
    blueSubConcHist(i) = blueSubConc;
end

figure
plot(time, blueSubConcHist);
xlabel('time (s)');
ylabel('conc (M)');
end