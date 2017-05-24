%%Test Sobel
rgbLena = imread('lena.png');
grayLena = rgb2gray(rgbLena);
imshow(grayLena);

[e] = Sobel(grayLena,40);

figure;
imshow(e);