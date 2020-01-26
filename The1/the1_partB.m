%Ulascan Deniz Genc  id:2099034
%Ali Alper Yüksel    id:2036390

b1 = imread('B1.jpg');
b2 = imread('B2.jpg');
b3 = imread('B3.jpg');
b4 = imread('B4.jpg');

out1 = histmatch(b1,b2);
imwrite(out1 , 'B1B2_histmatch_output.jpg');
saveas(histogram(out1), 'B1B2_histmatch.jpg');

out2 = histmatch(b2,b1);
imwrite(out2 , 'B2B1_histmatch_output.jpg');
saveas(histogram(out2), 'B2B1_histmatch.jpg');

out3 = histmatch(b3,b4);
imwrite(out3 , 'B3B4_histmatch_output.jpg');
saveas(histogram(out3), 'B3B4_histmatch.jpg');

out4 = histmatch(b4,b3);
imwrite(out4 , 'B4B3_histmatch_output.jpg');
saveas(histogram(out4), 'B4B3_histmatch.jpg');



function out = histmatch(target_image,ref)

rows = size(target_image, 1);
cols = size(target_image, 2);
L = 256;
histogram = zeros(L, 3);

%// Computing histogram of target image
for i = 1:rows
    for j = 1:cols
        for k = 1:3
            s_k = target_image(i, j, k);
            histogram(s_k + 1, k) = histogram(s_k + 1, k) + 1; 
        end
    end
end


rows_ref = size(ref, 1);
cols_ref = size(ref, 2);

histogram_ref = zeros(L, 3);

%// Computing histogram of reference image

for i = 1:rows_ref
    for j = 1:cols_ref
        for k = 1:3
            s_k = ref(i, j, k);
            histogram_ref(s_k + 1, k) = histogram_ref(s_k + 1, k) + 1;  
        end
    end
end


cdf = cumsum(histogram) / numel(target_image); %// Compute CDFs
cdf_ref = cumsum(histogram_ref) / numel(ref);

M = zeros(L,3,'uint8'); %// Store mapping - Cast to uint8 to respect data type

%// Compute the mapping:
%// Subtract each element of cdf of target image from cdf of ref image and
%// get the minimum from the difference array
for i = 1:L
    for j = 1:3
    [~, index] = min(abs(cdf(i, j) - cdf_ref(:, j)));
    M(i, j) = index - 1;
    end
end
%// Now apply the mapping to get first image to make
%// the image look like the distribution of the second image
out = M(double(target_image)+1);
end



