%Ulascan Deniz Genc  id:2099034
%Ali Alper Yüksel    id:2036390



clear;
clc;

A1 = imread('A1.png');
A2 = imread('A2.png');
A3 = imread('A3.png');
A4 = imread('A4.png');
A5 = imread('A5.png');
A6 = imread('A6.png');

A1_height = size(A1,1);
A1_width = size(A1,2);
A2_height = size(A2,1);
A2_width = size(A2,2);
A3_height = size(A3,1);
A3_width = size(A3,2);
A4_height = size(A4,1);
A4_width = size(A4,2);
A5_height = size(A5,1);
A5_width = size(A5,2);
A6_height = size(A6,1);
A6_width = size(A6,2);

%-------------------------------- A1 --------------------------------------
A1_gray = rgb2gray(A1);


A1_binary = zeros(A1_height, A1_width, 'logical');
for y=1:A1_height
    for x=1:A1_width
        if (A1_gray(y,x) > 50)
            A1_binary(y, x) = 0;
        else
            A1_binary(y, x) = 1;
        end
    end
end

SE = disk_matrix(5);
A1_binary = imclose(A1_binary, SE); % Apply closing operation

[result, n] = bwlabel(A1_binary);


%figure, imshow(A1_gray);
%figure, imshow(result);
imwrite(result, 'part1_A1.png');
fprintf('The number of flying jets in image A1 is %d\n', n);



%-------------------------------- A2 --------------------------------------

A2_gray = rgb2gray(A2);

% Threshold
A2_binary = zeros(A2_height, A2_width, 'logical'); % Create a binary image
for y=1:A2_height
    for x=1:A2_width
        if (A2_gray(y,x) > 60  & A2_gray(y,x) < 100)
            A2_binary(y, x) = 1;
        else
            A2_binary(y, x) = 0;
        end
    end
end

SE = disk_matrix(3);
A2_binary_1 = imclose(A2_binary, SE);

SE = disk_matrix(8);
A2_binary_2 = imopen(A2_binary_1, SE);

SE = disk_matrix(15);
A2_binary_3 = imclose(A2_binary_2, SE);



[result, n] = bwlabel(A2_binary_3);


imwrite(result, 'part1_A2.png');
fprintf('The number of flying jets in image A2 is %d\n', n);


%-------------------------------- A3 --------------------------------------

A3_gray = rgb2gray(A3);


% Threshold
A3_binary = zeros(A3_height, A3_width, 'logical'); % Create a binary image
for y=1:A3_height
    for x=1:A3_width
        if (A3_gray(y,x) > 50)
            A3_binary(y, x) = 0;
        else
            A3_binary(y, x) = 1;
        end
    end
end


SE = disk_matrix(2); % Structuring element
A3_binary = imclose(A3_binary, SE);

 SE = disk_matrix(7); % Structuring element
A3_binary = imclose(A3_binary, SE);

 SE = disk_matrix(2); % Structuring element
A3_binary = imopen(A3_binary, SE);

[result, n] = bwlabel(A3_binary);


imwrite(result, 'part1_A3.png');
fprintf('The number of flying jets in image A3 is %d\n', n);



%-------------------------------- A4 --------------------------------------

A4_gray = rgb2gray(A4);

% Threshold
A4_binary = zeros(A4_height, A4_width, 'logical'); % Create a binary image
for y=1:A4_height
    for x=1:A4_width
        if (A4_gray(y,x) > 40)
            A4_binary(y, x) = 0;
        else
            A4_binary(y, x) = 1;
        end
    end
end
 

SE = cubuk_matrix(10); % Structuring element
A4_binary = imopen(A4_binary, SE);
SE = disk_matrix(4);
A4_binary = imclose(A4_binary, SE);


[result, n] = bwlabel(A4_binary);

imwrite(result, 'part1_A4.png');
fprintf('The number of flying jets in image A4 is %d\n', n);


%-------------------------------- A5 --------------------------------------

A5_gray = rgb2gray(A5);

% Threshold
A5_binary = zeros(A5_height, A5_width, 'logical'); % Create a binary image
for y=1:A5_height
    for x=1:A5_width
        if (A5_gray(y,x) > 80)
            A5_binary(y, x) = 0;
        else
            A5_binary(y, x) = 1;
        end
    end
end
%figure,imshow(A5_binary);

SE = disk_matrix(3);
A5_binary = imopen(A5_binary, SE);


SE = disk_matrix(20);
A5_binary = imclose(A5_binary, SE);

SE = disk_matrix(5);
A5_binary = imclose(A5_binary, SE);

SE = disk_matrix(2);
A5_binary = imclose(A5_binary, SE);


SE = disk_matrix(15);
A5_binary = imopen(A5_binary, SE);


%figure,imshow(A5_binary);


[result, n] = bwlabel(A5_binary);

imwrite(result, 'part1_A5.png');
fprintf('The number of flying jets in image A5 is %d\n', n);

%-------------------------------- A6 --------------------------------------

A6_gray = rgb2gray(A6);

% Threshold
A6_binary = zeros(A6_height, A6_width, 'logical'); % Create a binary image
for y=1:A6_height
    for x=1:A6_width
        if (A6_gray(y,x) > 1)
            A6_binary(y, x) = 0;
        else
            A6_binary(y, x) = 1;
        end
    end
end


SE = cubuk_matrix(8);
A6_binary = imopen(A6_binary, SE);




SE = disk_matrix(20);
A6_binary = imdilate(A6_binary, SE);


[result, n] = bwlabel(A6_binary);

imwrite(result, 'part1_A6.png');
fprintf('The number of flying jets in image A6 is %d\n', n);


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


function [ se ] = cubuk_matrix( r )
%DISK_MATRIX Creates a binary matrix with a disk of 1's inside.
% Size of the output matrix is 2*r-1.
size = r;

se = zeros(1, size);

   for x=1:size
       se(1, x) = 1;   
   end 


end