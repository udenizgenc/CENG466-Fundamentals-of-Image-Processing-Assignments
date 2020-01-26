%Ali Alper Yüksel, 2036390
%Ulaþcan Deniz Genç, 2099034

clear;
clc;



I1 = imread('C1.png');
c1_s  = dir('C1.png');
compression(I1,1,c1_s);

I2 = imread('C2.png');
I2_gray = rgb2gray(I2);
c2_s  = dir('C1.png');
compression(I2_gray,2,c2_s);

I3 = imread('C3.png');
c3_s  = dir('C1.png');
compression(I3,3,c3_s);

I4 = imread('C4.png');
I4_gray = rgb2gray(I4);
c4_s  = dir('C1.png');
compression(I4_gray,4,c4_s);

I5 = imread('C5.png');
c5_s  = dir('C1.png');
compression(I5,5,c5_s);


function compression(I,cx,cx_s);
C1_height = size(I, 1);
C1_width = size(I, 2);

I_double = im2double(I);

% ------ wavelet transform of Image -----------------------
[cA,cH,cV,cD] = dwt2(I_double,'haar');

cA = cA/2.0;

%-------------- quantizing Image with 7 multitresh --------
thresh = multithresh(cA,7);
valuesMax = [thresh max(cA(:))];
[I_max_quant, index] = imquantize(cA,thresh,valuesMax);

 

 
%----- adjust the image for before histogram ------------

if (min(I_max_quant(:)) < 0)
    mina = 0; 
else
    mina = min(I_max_quant(:));
    
end
if(max(I_max_quant(:)) > 1)
    maxa = 1; 
    
else
    maxa = max(I_max_quant(:)) ;   
    
end
Adjust_Image = imadjust(I_max_quant,[mina maxa],[0 1]);

hist1 = zeros(256,1);

rows = size(Adjust_Image, 1);
cols = size(Adjust_Image, 2);

Adjust_Image = uint8(round(Adjust_Image .* 255)); 


 
%-------------- Computing Histogram of quantized image -----
for i = 1:rows
 for j = 1:cols
       hist1(Adjust_Image(i,j)+1)=hist1(Adjust_Image(i,j)+1)+1;
  end
end

%----------- make 1-d array the image for huffman input -----

ImgVector1 = Adjust_Image(:);

%---------------- Huffman encoding on Quantize image ------
prob = hist1/(rows*cols);
symbols = 0:255;
[dict,avglen] = huffmandict(symbols,prob); 
comp = huffmanenco(ImgVector1,dict);


%---------------- Compression Ratio ----------------------
binarySig = de2bi(ImgVector1);
seqLen = numel(binarySig);

binaryComp = de2bi(comp);
encodedLen = numel(binaryComp);

fprintf("Compression Ratio photo of c%d: %f \n",cx,seqLen/encodedLen);

%---------------- Huffman decoding of compress file -------
dsig = huffmandeco(comp,dict);


%---------------- reshape the decoded file ---------------
reshape_I =reshape(dsig,rows,cols);





%------------- Inverse wavelet transform of image --------
Inverse_wave_I = idwt2(reshape_I,cH,cV,cD,'haar');

Inverse_wave_I_uint8 = uint8(Inverse_wave_I).* 2;
%-------------  Calculate MSE ----------------------------
sum = 0;
for i = 1:C1_height 
 for j = 1:C1_width
       sum = sum + exp(I_double(i,j)-Inverse_wave_I(i,j))^2;
  end
end

sum = sum / ((C1_height)*(C1_width));

fprintf("Mean Square Error (MSE) of photo c%d: %f \n",cx,sum);

 

%------------- COMPARING WITH JPEG ---------------------
sum2 = 0;
imwrite(I,'cx.jpeg');
I_jpeg = imread('cx.jpeg');
I_jpeg_double = double(I_jpeg);

c1_file_s = cx_s(1).bytes;
cj_s  = dir('cx.jpeg');
c1_jpeg_s = cj_s(1).bytes;
fprintf("Compression Ratio photo of with jpeg c%d: %f \n",cx,c1_file_s/c1_jpeg_s);

for i = 1:C1_height 
 for j = 1:C1_width
       sum2 = sum2 + exp(I_double(i,j)-I_jpeg_double(i,j))^2;
  end
end
sum2 = sum2 / ((C1_height)*(C1_width));

fprintf("Mean Square Error (MSE) of JPEG file c%d: %f \n",cx,sum2);

end