%% Test Harris
rgbLena = imread('lena.png');
grayLena = rgb2gray(rgbLena);
imshow(grayLena);

[C] = Harris(grayLena,4,500);

figure;
imshow(C);