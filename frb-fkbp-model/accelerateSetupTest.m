function func = accelerateSetupTest() 
    sbioloadproject('frb-fkbp-hrp-model.sbproj');
    sbioaccelerate(m1)
    func = createSimFunction(m1, {'reaction_1.kr', 'reaction_2.kr', 'reaction_3.kr', 'reaction_4.kr', 'reaction_5.kf'}, {'blueComp'}, {});
end