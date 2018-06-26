function test()
%Wasburn constants
solnVisc = 1e-3; %dynamic shear viscosity for water (Pa s)
solnST = 72.8e-3; %surface tension of water (N/m)
poreDiam = 561e-6; %diameter of capillary or pore (m)
contAng = 15; % contact angle of capillary against wall (degrees)


time = [0:.1:50];
dist = sqrt(solnST*poreDiam*cosd(contAng)*time/solnVisc/4);
plot(time, dist);
xlabel("time (s)");
ylabel("distance (m)");

angles = 0:90;
size(angles,2)
distVarAngle = angles;
finalDist = .02;
for i = 1:size(angles, 2)
   distVarAngle(i) = (finalDist^2)*4*solnVisc/(solnST*poreDiam*cosd(angles(i)));
end

radii = 0:1e-7:1e-5;
distVarRadius = 1:size(radii, 2);
for i = 1:size(radii,2)
    distVarRadius(i) = (finalDist^2)*4*solnVisc/(solnST*radii(i)*cosd(contAng));
end

figure;
subplot(1,2,1);
plot(angles, distVarAngle);
xlabel("angle (degrees)");
ylabel("time to reach 2cm (s)");

subplot(1,2,2);
plot(radii, distVarRadius);
xlabel("Capillary Radius (m)");
ylabel("time to reach 2cm (s)");

end