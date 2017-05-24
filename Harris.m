function [Corner] = Harris(Image,windowSize,threshold)
%% Harries Corner Detection
%% 1. Change of intensity for the shift (u,v), E ( u , v )
%% 2. do Taylor series and decompose E(u,v) to [u,v] M [u;v]
%% E(u,v) is an equation of an ellipse, where M is the covariance 
%% 3. Let lambda1 and lambda2 be eigenvalues of M
%% 4. Measure of cornerness in terms of lambda1 , lambda2. R = det M - k(traceM)^2

%% 1 for each window caculate M matrix
Image = double(Image);
H = fspecial('gaussian',3);
I = imfilter(Image,H,'conv','symmetric');
[gx,gy] = gradient(I);

[m,n] = size(Image);
Corner = zeros(size(Image));
for i = 1: m-windowSize
    for j = 1 : n -windowSize
        M(1,1) = sum(sum(gx(i:i+windowSize,j:j+windowSize).^2));
        M(1,2) = sum(sum(gx(i:i+windowSize,j:j+windowSize).*gy(i:i+windowSize,j:j+windowSize)));
        M(2,1) = sum(sum(gx(i:i+windowSize,j:j+windowSize).*gy(i:i+windowSize,j:j+windowSize)));
        M(2,2) = sum(sum(gy(i:i+windowSize,j:j+windowSize).^2));
        
%% calculate R
        R(i,j) = det(M) - trace(M);
    end
end

%% apply local maxima threshold
for i = 2:m-1-windowSize
    for j = 2:n-1-windowSize
        if R(i,j)>threshold
            if R(i,j)>R(i,j+1) && R(i,j)>R(i+1,j+1) && R(i,j)>R(i-1,j+1) && ...
                    R(i,j)>R(i+1,j-1) && R(i,j)>R(i,j-1) && R(i,j)>R(i-1,j-1) ...
                    && R(i,j)>R(i-1,j) && R(i,j)>R(i+1,j)
                Corner(i+round(windowSize/2),j+round(windowSize/2))=1;
            end
        end
    end
end
    
