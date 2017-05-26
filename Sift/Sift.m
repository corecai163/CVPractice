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

% normalize pixel values in [0, 1]
% and double the image to form first level of first octave
Image = double(Image);
Image = Image - min(Image(:));
Image = Image / max(Image(:));
Image = imresize(Image,2);	
[M,N] = size(Image);

% calculate DOG
% DoG is a cell with 3D array. Dog{octave}(numScale,M,N)
% Dog = ConsturctDoG(Image,numOctave,numScale,k,sigma);
for i = 1:numOctave
    for j = 1:numScale
        H = fspecial('gaussian',3,k^(2*i+j-3)*sigma);
        I{i}(j,:,:) = imfilter(Image,H,'conv','symmetric');
    end
end
for i = 1:numOctave
    for j = 1:numScale-1
        Dog{i}(j,:,:) = I{i}(j+1,:,:)-I{i}(j,:,:);
    end
end
% For each octave
% Compare a pixel (X) with 26 pixels in current and adjacent scales 
% Select a pixel (X) if larger/smaller than all 26 pixels
% Large number of extrema, computationally expensive
% Detect the most stable subset with a coarse sampling of scales
for i = 1: numOctave
    localMax = FindMax(Dog{i});
    localMin = FindMax(-Dog{i});
    % 2-D maxtrix, each row indicates a candidate key points
    % localMax(:,1) = scale
    % localMax(:,2) = row
    % localMax(:,3) = column
    candKeys = [localMax;localMin];
    
%----------------- accurate keypoint localization ----------------% 
    % Initial Outlier Rejection
    % Reject Low contrast candidates and Poorly localized candidates along an edge
    % Further Outlier Rejection
    modifyKeys = FiltKeypoints(candKeys, Dog{i});
    % modifyKeys is a 2-D maxtrix, each row indicates a candidate key
    % points as localMax
    
    
%---------------- orientation histogram and descriptor -----------------%     

	keyPoints = OrientDes(modifyKeys, I{i});
    Descriptors = [Descriptors;keyPoints];
    Locations = [Locations;modifyKeys];
end
