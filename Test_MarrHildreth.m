%%Test MarrHildreth
rgbLena = imread('lena.png');
grayLena = rgb2gray(rgbLena);
imshow(grayLena);

[e] = MarrHildreth(grayLena,0);

figure;
imshow(e);