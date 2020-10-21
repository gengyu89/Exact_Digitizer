function YUV_dist = uv_distance(RGB_1, RGB_2)
%UV_DISTANCE Subroutine for calculating the
%   Euclidean distance of two colors in the YUV space
%   with input given as RGB vectors.


% define the transformation matrix
trns = [0.29900, 0.58700, 0.11400; ...
    -0.14713, -0.28886, 0.43600; ...
    0.61500, -0.51499, -0.10001];

% forced conversion into column vectors
if size(RGB_1, 2) > 1
    RGB_1 = RGB_1';
end

if size(RGB_2, 2) > 1
    RGB_2 = RGB_2';
end

% convert both colors into YUV
YUV_1 = trns * RGB_1;
YUV_2 = trns * RGB_2;
% fprintf('YUV 1:\n'); disp(YUV_1);
% fprintf('YUV 2:\n'); disp(YUV_2);

% calculate euclidean distance in the new color space
YUV_dist = sqrt(sum((YUV_2 - YUV_1) .^ 2));

% References
%   https://stackoverflow.com/questions/9018016/how-to-compare-two-colors-for-similarity-difference
%   https://stackoverflow.com/questions/5392061/algorithm-to-check-similarity-of-colors
%   https://softpixel.com/~cwright/programming/colorspace/yuv/
% 


end

