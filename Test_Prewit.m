%%Test Prewit
rgbLena = imread('lena.png');
grayLena = rgb2gray(rgbLena);
imshow(grayLena);

[ex,ey] = Prewit(grayLena,40);

figure;
imshow(ex);
figure;
imshow(ey);