%Ali Alper Yüksel, 2036390
%Ulaþcan Deniz Genç, 2099034
rgbImage1 = imread('B1.jpg');
rgbImage2 = imread('B2.jpg');

result_image1 = the2_partb(rgbImage1);
result_image2 = the2_partb(rgbImage2);

imwrite(result_image1,'B1_result.jpg');
imwrite(result_image2,'B2_result.jpg');

function result_image = the2_partb(rgbImage)

%Convert colored image into gray-scale image
gray_image = rgb2gray(rgbImage);
height = size(gray_image, 1);
width = size(gray_image, 2);
%Take FT of image
ft_image = fft2(gray_image);
%figure, imshow(fftshift(abs(ft_image)), [0, 40000]); % display the transform

%Construct the frequency domain filter
center_x = round(width/2);
center_y = round(height/2);
filter = zeros(height, width);

%Apply high-pass filter with radius 130
for x = 1:width
   for y = 1:height
      distance = sqrt((x-center_x)^2 + (y-center_y)^2);
      if((distance > 120))
         filter(y, x) = 1;
      end
   end
end

filter = fftshift(filter); % shift back
ft_image = ft_image .* filter; % element-wise multiplication
%figure, imshow(fftshift(abs(ft_image)), [0, 40000]); % display filtered transform
transformed_image = abs(ifft2(ft_image));

%Transformed values should be mapped
transformed_image = transformed_image/255.0; % Adjust the color range to [0, 1]
%Map the gray levels to the range [0.0, 1.0] to show edges in a marked way 
transformed_image = imadjust(transformed_image,[min(transformed_image(:)); max(transformed_image(:))],[0.0; 1.0]);


%figure, imshow(result); % Display the output image 
result_image = transformed_image;

end

