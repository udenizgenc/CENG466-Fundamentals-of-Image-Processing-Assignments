%Ulascan Deniz Genc  id:2099034
%Ali Alper Yüksel    id:2036390

function result_bil = bilinear_interpolation(sh,b)
    x = b(1);
    y = b(2);
    result_bil =imresize(sh,[x,y],'bilinear');

end