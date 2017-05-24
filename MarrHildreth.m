function [Edge] = MarrHildreth(Image,threshold)
%%Marr Hildreth Edge Detector
%%0. Smooth Image by Gaussian Filter
%%1. Apply Laplacian 
%%OR directly Deriving the Laplacian of Gaussian (LoG)
%%2. Find zero crossings
%%3. Calculate slope of zero crossings
%%4. Thresholding
Image = double(Image);
% H = fspecial('log',5,1.5);
H = TwoDLoG(2,5);
I = imfilter(Image,H,'conv','symmetric');
[m,n] = size(I);
slope = zeros(size(I));
Edge = zeros(size(I));
for i = 1:m
    for j = 2:n
        %find zero cross
        if I(i,j-1)*I(i,j)<0
            slope(i,j-1)=abs(I(i,j-1))+abs(I(i,j));
            slope(i,j)=abs(I(i,j-1))+abs(I(i,j));
        end
        if I(i,j-1)*I(i,j)==0
            if j<n && I(i,j-1)*I(i,j+1)<0 
                slope(i,j)=abs(I(i,j-1))+abs(I(i,j+1));
            end
            
        end
        
    end
end
Edge(slope>threshold)=1;

