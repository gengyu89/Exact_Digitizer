function value = fuzzy_match(RGB, cbar_regrid, threshold)
%FUZZY_MATCH Subroutine for finding the best
%    matching color and returning the corresponding value
%    on an interpolated color scale.
% 
% The output is set to NaN in the following two cases:
%   (1) A state boundary / annotation text is encountered
%   (2) There are multiple smallest YUV distances
% 


% split data into vectors
cbar_val = cbar_regrid(:,1);
cbar_RGB = cbar_regrid(:,2:4);  % N x 3 matrix

% pre allocate space
N_regrid = size(cbar_regrid, 1);
YUV_dist = zeros(N_regrid, 1);

% calculate Euclidean distances
% in the YUV space
for i = 1 : N_regrid
    YUV_dist(i) = uv_distance(RGB, cbar_RGB(i,:));
end

% locate the minimum value
YUV_min = min(YUV_dist);
idx_min = find(YUV_dist == YUV_min);

% determine the reading
value = cbar_val(idx_min);

% check uniqueness
if length(idx_min) > 1  % the min distance is not unique
    warning('Multiple matching colors found!');
    value = NaN;
end

% check validity
if YUV_min > threshold  % outside of the color scale
    warning('No match found!');
    value = NaN;
end


end

