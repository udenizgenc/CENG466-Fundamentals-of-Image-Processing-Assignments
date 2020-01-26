%Ulascan Deniz Genc  id:2099034
%Ali Alper Yüksel    id:2036390

rgbImage1 = imread('C1.jpg');
rgbImage2 = imread('C2.jpg');

result_image1 = the1_partc2(rgbImage1);
result_image2 = the1_partc(rgbImage2);

imwrite(result_image1,'C1_result.jpg');
imwrite(result_image2,'C2_result.jpg');
% Display image that filtered by series of filter ( mean filter + custom gaussian filter)
montage({result_image1,result_image2});

function result_image = the1_partc(rgbImage)

% Extract the individual red, green, and blue color channels.
redChannel1 = rgbImage(:, :, 1);
greenChannel1 = rgbImage(:, :, 2);
blueChannel1 = rgbImage(:, :, 3);

% Filter with mean Filter by 5x5 kernel 
redChannel = the1_convolution(redChannel1 , ones(5)/25 )   ;
greenChannel = the1_convolution(greenChannel1 , ones(5)/25 );    
blueChannel = the1_convolution(blueChannel1 , ones(5)/25) ;    

% Construct Gaussian Kernel
m=9; 
n=9;
sigma=15;
[h1, h2]=meshgrid(-(m-1)/2:(m-1)/2, -(n-1)/2:(n-1)/2);
hg= exp(-(h1.^2+h2.^2)/(2*sigma^2)); %Gaussian function
k=hg ./sum(hg(:));

% Convolve the three separate color channels.
redBlurred = the1_convolution(redChannel, k);
greenBlurred = the1_convolution(greenChannel, k);
blueBlurred = the1_convolution(blueChannel, k);

% Recombine separate color channels into a single, true color RGB image.
result_image = cat(3, uint8(redBlurred), uint8(greenBlurred), uint8(blueBlurred));
end

function result_image = the1_partc2(rgbImage)

% Extract the individual red, green, and blue color channels.
redChannel1 = rgbImage(:, :, 1);
greenChannel1 = rgbImage(:, :, 2);
blueChannel1 = rgbImage(:, :, 3);

% Filter with mean Filter by 5x5 kernel 
redChannel = the1_convolution(redChannel1 , ones(9)/81 )   ;
greenChannel = the1_convolution(greenChannel1 , ones(9)/81 );    
blueChannel = the1_convolution(blueChannel1 , ones(9)/81) ;    

% Construct Gaussian Kernel
m=12; 
n=12;
sigma=15;
[h1, h2]=meshgrid(-(m-1)/2:(m-1)/2, -(n-1)/2:(n-1)/2);
hg= exp(-(h1.^2+h2.^2)/(2*sigma^2)); %Gaussian function
k=hg ./sum(hg(:));

% Convolve the three separate color channels.
redBlurred = the1_convolution(redChannel, k);
greenBlurred = the1_convolution(greenChannel, k);
blueBlurred = the1_convolution(blueChannel, k);

% Recombine separate color channels into a single, true color RGB image.
result_image = cat(3, uint8(redBlurred), uint8(greenBlurred), uint8(blueBlurred));
end


% below function only for sampling in report of denoising gaussian noise
function test_output = non_local_mean_filter(noisyRGB)
noisyLAB = rgb2lab(noisyRGB);

roi = [210,24,52,41];
patch = imcrop(noisyLAB,roi);

patchSq = patch.^2;
edist = sqrt(sum(patchSq,3));
patchSigma = sqrt(var(edist(:)));

DoS = 1.5*patchSigma;
denoisedLAB = imnlmfilt(noisyLAB,'DegreeOfSmoothing',DoS);

test_output = lab2rgb(denoisedLAB,'Out','uint8');
 
end