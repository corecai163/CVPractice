function [Edge] = Canny(Image,high,low)
%%1 Smooth image with Gaussian filter
%%2 Compute derivative of filtered image
%%3 Find magnitude and orientation of gradient
%%4 Apply “Non-maximum Suppression”
%%5 Apply “Hysteresis Threshold”

%% 1
Image = double(Image);
H = fspecial('gaussian',3);
I = imfilter(Image,H,'conv','symmetric');
Edge = zeros(size(I));
%% 2
[gx,gy] = gradient(I);

%% 3
magnitude = sqrt(gx.^2+gy.^2);

%% 4 use nearest 8 pixels
[m,n] = size(I);
t = gy./gx;
max = zeros(size(I));
for i = 2: m-1
    for j = 2:n-1

        if t(i,j) < -2
            if magnitude(i,j)>magnitude(i,j+1) && magnitude(i,j)>magnitude(i,j-1)
                max(i,j) = magnitude(i,j);
            end
        end
        
        if -1/2 > t(i,j) > -2
            if magnitude(i,j)>magnitude(i+1,j-1) && magnitude(i,j)>magnitude(i-1,j+1)
                max(i,j) = magnitude(i,j);
            end
        end
        
        if -1/2 < t(i,j) < 1/2
            if magnitude(i,j)>magnitude(i+1,j) && magnitude(i,j)>magnitude(i-1,j)
                max(i,j) = magnitude(i,j);
            end
        end
        
        if 1/2 < t(i,j) < 2
            if magnitude(i,j)>magnitude(i+1,j+1) && magnitude(i,j)>magnitude(i-1,j-1)
                max(i,j) = magnitude(i,j);
            end
        end
        
    end
end
    
%% 5 use four connected
for i = 2:m-1
    for j = 2:n-1
        if max(i,j)>high
            Edge(i,j)=1;
        else
            if max(i,j) > low
                if max(i,j+1)>high
                    Edge(i,j)=1;
                end
                if max(i,j-1)>high
                    Edge(i,j)=1;
                end
                if max(i+1,j)>high
                    Edge(i,j)=1;
                end
                if max(i-1,j)>high
                    Edge(i,j)=1;
                end
            end
        end
    end
end
end