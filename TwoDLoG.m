function Filter = TwoDLoG(sigma,windowSize)
%% My Relization of 2D-LoG

%% 2D Gaussian function: 1/(sqrt(2*Pi*sigma^2)) * exp(-(x^2+y^2)/(2*sigma^2))
%% Do Laplacian : -1/(sqrt(2Pi)sigma^3)*(2-(x^2+y^2)/sigma^2)exp(-(x^2+y^2)/(2*sigma^2))
Filter = zeros(windowSize);
for i = 1:2*windowSize+1
    for j = 1:2*windowSize+1
        Filter(i,j)=-1/(sqrt(2*pi)*sigma^3)*(2-((i-1-windowSize)^2+(j-1-windowSize)^2)/sigma^2) ...
        *exp(-((i-1-windowSize)^2+(j-1-windowSize)^2)/(2*sigma^2));
    end
end
end