function [Descriptors,Locations] = Sift(Image)
%% Goal Extracting distinctive invariant features
%% Correctly matched against a large database of features from many images
%% Invariance to image scale and rotation
%% Robustness to
%%     Affine distortion,
%%     Change in 3D viewpoint,
%%     Addition of noise,
%%     Change in illumination.

%% 1 Scale space peak selection
%       Potential locations for finding features
%% 2 Key point localization
%       Accurately locating the feature key points
%% 3 Orientation Assignment
%       Assigning orientation to the key points
%% 4 Key point descriptor
%       Describing the key point as a high dimensional vector
numOctave = 3;
numScale = 4;
sigma = 1;
k=sqrt(2);
%1 Building a scale space using Difference of Gaussian
Image = double(Image);
for i = 1:numOctave
    for j = 1:numScale
        H = fspecial('gaussian',3,k^(2*i+j-3)*sigma);
        I{i,j} = imfilter(Image,H,'conv','symmetric');
    end
end
for i = 1:numOctave
    for j = 1:numScale-1
        Dog{i,j} = I{i,j+1}-I{i,j};
    end
end

% Compare a pixel (X) with 26 pixels in current and adjacent scales 
% Select a pixel (X) if larger/smaller than all 26 pixels
% Large number of extrema, computationally expensive
% Detect the most stable subset with a coarse sampling of scales
for i = 1 : numOctave
    for j = 2 : numScale-2
        RMax = imregionalmax(Dog{i,j});
        RMin = imregionalmin(Dog{i,j});
        Extrema{i,j} = RMax+RMin;
    end
end
% Initial Outlier Rejection

