%Ulascan Deniz Gen�  id:2099034
%Ali Alper Y�ksel    id:2036390

function result_bic = bicubic_interpolation(sh,b)
    x = b(1);
    y = b(2);
    result_bic =imresize(sh,[x,y],'bicubic');

end