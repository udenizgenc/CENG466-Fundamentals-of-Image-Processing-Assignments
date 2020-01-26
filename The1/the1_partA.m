%Ulascan Deniz Genc  id:2099034
%Ali Alper Yüksel    id:2036390

%----- Reading Org. Images and Size of Them ---------
a1 = imread('A1.jpg');
a2 = imread('A2.jpg');
a3 = imread('A3.jpg');

[x1,y1,z1] = size(a1);
[x2,y2,z2] = size(a2);
[x3,y3,z3] = size(a3);
%------------- Reading Shrink Images ----------------
a1_sh = imread('A1_shrinked.jpg');
a2_sh = imread('A2_shrinked.jpg');
a3_sh = imread('A3_shrinked.jpg');

%---------------- Resizing Images -------------------
a1_result_bil = bilinear_interpolation(a1_sh,[x1,y1]);
a1_result_bic = bicubic_interpolation(a1_sh,[x1,y1]);

a2_result_bil = bilinear_interpolation(a2_sh,[x2,y2]);
a2_result_bic = bicubic_interpolation(a2_sh,[x2,y2]);

a3_result_bil = bilinear_interpolation(a3_sh,[x3,y3]);
a3_result_bic = bicubic_interpolation(a3_sh,[x3,y3]);

%------------- Writing in Files ---------------------
 
imwrite(a1_result_bil , 'A1_result_bilinear.jpg');
imwrite(a1_result_bic , 'A1_result_bicubic.jpg');
imwrite(a2_result_bil , 'A2_result_bilinear.jpg');
imwrite(a2_result_bic , 'A2_result_bicubic.jpg');
imwrite(a3_result_bil , 'A3_result_bilinear.jpg');
imwrite(a3_result_bic , 'A3_result_bicubic.jpg');

%------------- Euclidean Distance -------------------
Dist_a1_bil = sqrt(sum((a1_result_bil(:) - a1(:)) .^ 2));
Dist_a1_bic = sqrt(sum((a1_result_bic(:) - a1(:)) .^ 2));

Dist_a2_bil = sqrt(sum((a2_result_bil(:) - a2(:)) .^ 2));
Dist_a2_bic = sqrt(sum((a2_result_bic(:) - a2(:)) .^ 2));

Dist_a3_bil = sqrt(sum((a3_result_bil(:) - a3(:)) .^ 2));
Dist_a3_bic = sqrt(sum((a3_result_bic(:) - a3(:)) .^ 2));