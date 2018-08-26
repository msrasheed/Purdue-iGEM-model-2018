function dydt = rxnODE(t,y)
ipqsR1 = 1;
ipqsR2 = 2;
ifar = 3;
ipqFar = 4;
ipq2Far = 5;
ipqFarpq = 6;
iTMB = 7;
iblue = 8;

pqsR1 = y(ipqsR1);
pqsR2 = y(ipqsR2);
farnesol = y(ifar);
pqsR_far = y(ipqFar);
pqsR2_far = y(ipq2Far);
pqsR_far_pqsR = y(ipqFarpq);
TMB = y(iTMB);
blueComp = y(iblue);

dydt = ones(8,1);

kf1 = 1;
kr1 = 2.6e-5;
kf2 = 1;
kr2 = 2.0e-10;
kf3 = 1;
kr3 = 1.0e-13;
kf4 = 1;
kr4 = 1.2e-8;
k_cat = 435;
K_m = 9.0e-5;

reaction_1 = kf1*pqsR1*farnesol-kr1*pqsR_far;
reaction_2 = kf2*pqsR2*farnesol-kr2*pqsR2_far;
reaction_3 = kf3*pqsR_far*pqsR2-kr3*pqsR_far_pqsR;
reaction_4 = kf4*pqsR2_far*pqsR1-kr4*pqsR_far_pqsR;
reaction_6 = (k_cat*pqsR_far_pqsR)*TMB/(K_m+TMB);

dydt(ipqsR1) = (-reaction_1 - reaction_4);
dydt(ipqsR2) = (-reaction_2 - reaction_3);
dydt(ifar) = (-reaction_1 - reaction_2);
dydt(ipqFar) = (reaction_1 - reaction_3);
dydt(ipq2Far) = (reaction_2 - reaction_4);
dydt(ipqFarpq) = (reaction_3 + reaction_4);
dydt(iTMB) = (-reaction_6);
dydt(iblue) = (reaction_6);

if y(iTMB) < 0
    dydt(iTMB) = 0;
    dydt(iblue) = 0;
end

end