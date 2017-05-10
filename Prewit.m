function [EdgeX,EdgeY] = Prewit(Image,threshold)
%%Prewit edge detector
%%0. Smooth the Image
%%1. Compute X and Y derivatives
%%2. Find gradient magnitude
%%3. Threshold gradient magnitude
H = fspecial('average',3);
I = imfilter(Image,H,'conv','symmetric');
%%step0 step1
Gx = [-1,0,1;-1,0,1;-1,0,1];
Gy = [-1,0,1;-1,0,1;-1,0,1]';
gx = imfilter(I,Gx);
gy = imfilter(I,Gy);
%%step3
EdgeX = zeros(size(I));
EdgeY = zeros(size(I));
EdgeX(gx>threshold)=1;
EdgeY(gy>threshold)=1;

