function [sampled, N_vis, N_exc] = process_img(flag, ...
    X_range, Y_range, N_pixels, RGBimage, cbar_regrid, user_data)
%PROCESS_IMG Subroutine for reading the RGB values
%   of an image at sampled points and converting them
%   into values.
% 
% N_pixels
%    - the number of pixels to skip along each direction
% 


%% Collect basic information.

% get dimensions of rgbimage
[N_row, N_col, ~] = size(RGBimage);

% calculate axis expands
X_expand = abs(X_range(2) - X_range(1));
Y_expand = abs(Y_range(2) - Y_range(1));

% define the upperleft corner of the map
X_min = min(X_range);
Y_max = max(Y_range);

% create pixel arrays to traverse
if user_data
    pixels = load(['./output/', flag, 'locations.dat']);
    N_array = size(pixels,1);  % namespace N_pixels has been taken
    X_array = pixels(:,1); Y_array = pixels(:,2);
else
    X_grids = N_pixels : N_pixels : N_col;
    Y_grids = N_pixels : N_pixels : N_row;
    
    % allocation
    N_array = length(X_grids) * length(Y_grids);
    X_array = zeros(1,N_array);
    Y_array = zeros(1,N_array);
    
    % flatten the grids into 1d vectors
    ij = 0;
    for Yj = Y_grids
        for Xi = X_grids
            ij = ij + 1;
            X_array(ij) = Xi; Y_array(ij) = Yj;
        end
    end
end


%% Process and save the data.

disp('Converting...');

% initialize output
sampled = [];
N_vis = 0; N_exc = 0;

% time the computation section
tic();

% process through the image
for ij = 1:N_array
    % read the RGB values
    X = X_array(ij); Y = Y_array(ij);
    RGB = impixel(RGBimage, X, Y);
    
    % convert into lon and lat
    lon = X_min + (X-1)/(N_col-1) * X_expand;
    lat = Y_max - (Y-1)/(N_row-1) * Y_expand;
    
    % convert the RGB into a reading
    value = fuzzy_match(RGB, cbar_regrid, 20);
    fprintf('(%d, %d) [%d, %d, %d] ', X, Y, RGB);
    fprintf('=> (%f, %f) %f\n', lon, lat, value);
    N_vis = N_vis + 1;
    
    % update outputs
    if isnan(value)
        N_exc = N_exc + 1;
    else
        sampled = [sampled; [lon, lat, value]];
    end
end

% stop the timer
toc();
fprintf('\n');

% save the data
filename = ['./output/', flag, 'digitized.dat'];
fp = fopen(filename, 'w');
fprintf(fp, '%11f%11f  %.6f\n', sampled');
fclose(fp);

% report to the command window
fprintf('Done. %d pixels processed.', N_vis);
fprintf(' %d excluded.\n', N_exc);
fprintf('File saved as: %s\n', filename);
fprintf('\n');


end

