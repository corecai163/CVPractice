%%Test Canny
rgbLena = imread('lena.png');
grayLena = rgb2gray(rgbLena);
imshow(grayLena);

[e] = Canny(grayLena,8,2);

figure;
imshow(e);