function [Edge] = Sobel(Image,threshold)
%%Sobel edge detector
%%0. Smooth the Image
%%1. Compute X and Y derivatives
%%2. Find gradient magnitude
%%3. Threshold gradient magnitude
H = fspecial('average',3);
I = imfilter(Image,H,'conv','symmetric');
%%step0 step1
Gx = [-1,0,1;-2,0,2;-1,0,1];
Gy = [-1,0,1;-2,0,2;-1,0,1]';
gx = double(imfilter(I,Gx));
gy = double(imfilter(I,Gy));
%%step3
g = sqrt(gx.^2+gy.^2);
Edge = zeros(size(I));
Edge(g>threshold)=1;
