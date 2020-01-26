%Ali Alper Yüksel, 2036390
%Ulaþcan Deniz Genç, 2099034
clc
clear
warning('off', 'Images:initSize:adjustingMag');

A1 = imread('A1.png');
A2 = imread('A2.png');
A3 = imread('A3.png');


A2_height = size(A2, 1);
A2_width = size(A2, 2);

A1_height = size(A1, 1);
A1_width = size(A1, 2);

A3_height = size(A3, 1);
A3_width = size(A3, 2);

%--------------------    A1   --------------------------------

%Take Ft of the image
A1_t = fft2(A1);
%figure, imshow(fftshift(abs(A1_t)), [0, 150000]);

% Construct the frequency domain filter
center_x = round(A1_width/2);
center_y = round(A1_height/2);
filter2 = ones(A1_height, A1_width);

for x = 1:A1_width
   for y = 1:A1_height
      distance = sqrt((x-center_x)^2 + (y-center_y)^2);
      if(distance > 54)
         filter2(y, x) = 0;
      end
   end
end
    
filter2 = fftshift(filter2); % shift back

A1_t = A1_t .* filter2; % element-wise multiplication

%figure, imshow(fftshift(abs(A1_t)), [0, 20000]);
A1_new = abs(ifft2(A1_t)); % reconstruct image from its transform

% Transformed values should be mapped.
A1_new = A1_new/255.0; % Adjust the color range to [0, 1]
% Map the gray levels to the range [0.0, 1.0]
if(max(A1_new(:)) > 1 )
    maxb = 1;
else 
    maxb = max(A1_new(:)) ;
end
if(min(A1_new(:)) < 0 )
    minb = 0;
else 
    minb = min(A1_new(:)) ;
end
A1_new = imadjust(A1_new,[minb; maxb],[0.0; 1.0]);

%figure, imshow(A1_new); % Display the output image 
imwrite(A1_new, 'A1_denoised.png');


%--------------------    A2    --------------------------------

%Take Ft of the image
A2_t = fft2(A2);
%figure, imshow(fftshift(abs(A2_t)), [0,5000]);

% Construct the frequency domain filter
center_x = round(A2_width/2);
center_y = round(A2_height/2);
filter1 = ones(A2_height, A2_width);
for x = 1:A2_width
   for y = 1:A2_height
      distance = sqrt((x-center_x)^2 + (y-center_y)^2);
      if((distance > 63 && distance < 85) || (distance > 280 && distance < 320))
         filter1(y, x) = 0;
      end
   end
end
filter1 = fftshift(filter1); % shift back
A2_t = A2_t .* filter1; % element-wise multiplication
%figure, imshow(fftshift(abs(A2_t)), [0, 40000]);
A2_new = abs(ifft2(A2_t));

% Transformed values should be mapped.
A2_new = A2_new/255.0; % Adjust the color range to [0, 1]
% Map the gray levels to the range [0.0, 1.0]
A2_new = imadjust(A2_new, [min(A2_new(:)); max(A2_new(:))], [0.0; 1.0]);

%figure, imshow(A3_new); % Display the output image 
imwrite(A2_new, 'A2_denoised.png');



%--------------------    A3    --------------------------------


redChannel1 = A3(:, :, 1);
greenChannel1 = A3(:, :, 2);
blueChannel1 = A3(:, :, 3);

% Transform the input image
redChannel1_t = fft2(redChannel1);
greenChannel1_t = fft2(greenChannel1);
blueChannel1_t = fft2(blueChannel1);

%figure, imshow(fftshift(abs(redChannel1_t)), [0,50000]);
%figure, imshow(fftshift(abs(greenChannel1_t)), [0,50000]);
%figure, imshow(fftshift(abs(blueChannel1_t)), [0,50000]);

red_new = a3_low(redChannel1,redChannel1_t,A3_width,A3_height);
green_new = a3_low(greenChannel1,greenChannel1_t,A3_width,A3_height);
blue_new = a3_low(blueChannel1,blueChannel1_t,A3_width,A3_height);

A3_new =cat(3, double(red_new), double(green_new), double(blue_new));
imwrite(A3_new, 'A3_denoised.png');


function A3_new = a3_low(A3,A3_t,A3_width,A3_height)
% Construct the frequency domain filter
center_x = round(A3_width/2);
center_y = round(A3_height/2);
filter3 = ones(A3_height, A3_width);
for x = 1:A3_width
   for y = 1:A3_height
      distance = abs(x-center_x)  + abs(y-center_y) ;
      if(distance > 50)
         filter3(y, x) = 0;
      end
   end
end
 
filter3 = fftshift(filter3); % shift back

%figure, imshow(fftshift(abs(A3_t)),[0, 500000]);
% Apply the filter
A3_t = A3_t .* filter3; % element-wise multiplication
%figure, imshow(fftshift(abs(A3_t)), [0, 500000]);
A3_new = abs(ifft2(A3_t));

normA = A3_new - min(A3_new(:));
normA = normA ./ max(normA(:)) ;

% Map the gray levels to the range [0.0, 1.0]
A3_new = imadjust(normA,[min(normA(:)); max(normA(:))],[0.0; 1.0]);
end