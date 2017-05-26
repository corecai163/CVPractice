function Dog = ConsturctDoG(Image,numOctave,numScale,k,sigma)

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
end