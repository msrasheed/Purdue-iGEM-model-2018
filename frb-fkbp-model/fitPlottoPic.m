img = imread('pdfGraph.png');
imshow(img);
figure();
%hold on
data = csvread('Default Dataset.csv');
semilogx(data(:,1), data(:,2));
grid on
