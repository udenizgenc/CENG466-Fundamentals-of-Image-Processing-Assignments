%Ulascan Deniz Genc  id:2099034
%Ali Alper Yüksel    id:2036390


C1 = imread('C1.jpg');
C2 = imread('C2.jpg');
C3 = imread('C3.jpg');
C4 = imread('C4.jpg');
C5 = imread('C5.jpg');


[DENEME,MASKED]= createMask(C1);
figure,imshow(MASKED)
[DENEME,MASKED]= createMask(C2);
figure,imshow(MASKED)
[DENEME,MASKED]= createMask(C3);
figure,imshow(MASKED)
[DENEME,MASKED]= createMask(C4);
figure,imshow(MASKED)
[DENEME,MASKED]= createMask(C5);
figure,imshow(MASKED)



function [BW,maskedRGBImage] = createMask(RGB)

I = rgb2hsv(RGB);
img = I;


% Define thresholds for channel 1 based on histogram settings
channel1Min = 0.90;
channel1Max = 0.05;
channel1q2Min = 0.18;
channel1q2Max = 0.19;

% Define thresholds for channel 2 based on histogram settings
channel2Min = 0.10;
channel2Max = 1;

% Define thresholds for channel 3 based on histogram settings
channel3Min = 0.1;
channel3Max = 0.9;

% Create mask based on chosen histogram thresholds
sliderBW = ( (I(:,:,1) >= channel1Min) | (I(:,:,1) <= channel1Max) ...
           |((I(:,:,1) >= channel1q2Min) & (I(:,:,1) <= channel1q2Max))) & ...
           (I(:,:,2) >= channel2Min ) & (I(:,:,2) <= channel2Max) & ...
           (I(:,:,3) >= channel3Min ) & (I(:,:,3) <= channel3Max) & ( I(:,:,3) > I(:,:,2) );

BW = sliderBW;
height = size(I, 1);
weight = size(I, 2);

if(weight<800)
SE = disk_matrix(20);
BW = imdilate(BW, SE);
BW = imclose(BW, SE);

SE = disk_matrix(40);
BW = imopen(BW, SE);
end

if(weight<1200 & weight>=800)
SE = disk_matrix(20);
BW = imdilate(BW, SE);
BW = imclose(BW, SE);

SE = disk_matrix(40);
BW = imopen(BW, SE);

SE = disk_matrix(100);
BW = imclose(BW, SE);

SE = disk_matrix(30);
BW = imerode(BW, SE);

SE = disk_matrix(10);
BW = imdilate(BW, SE);
end

if(weight<400)
SE = disk_matrix(20);
BW = imerode(BW, SE);
end

if(weight>1200 & weight<=2000)
SE = disk_matrix(5);
BW = imerode(BW, SE);
SE = disk_matrix(70);
BW = imdilate(BW, SE);
end

if(weight>2000)
SE = disk_matrix(30);
BW = imerode(BW, SE);
SE = disk_matrix(100);
BW = imdilate(BW, SE);
SE = disk_matrix(150);
BW = imdilate(BW, SE);
SE = disk_matrix(150);
BW = imdilate(BW, SE);
end
% Initialize output masked image based on input image.
maskedRGBImage = RGB;
% Set background pixels where BW is false to zero.
maskedRGBImage(repmat(~BW,[1 1 3])) = 0;






end




function [ se ] = disk_matrix( r )
%DISK_MATRIX Creates a binary matrix with a disk of 1's inside.
% Size of the output matrix is 2*r-1.
size = 2*r-1;
center = size/2.0;
se = zeros(size, size);
for y=1:size
   for x=1:size
       distance = sqrt((y-r)^2+(x-r)^2);
       se(y, x) = center > distance;   
   end 
end

end