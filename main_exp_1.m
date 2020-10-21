% script for digitizing a contour map by finding
% best matching colors from a pre-defined color scale
% 2020-10-06

clc
clf
clear all
close all


%% Process the color scale.

% set paths to dependencies
addpath(fullfile(pwd, 'borders'));
addpath(fullfile(pwd, 'functions'));
cbardata = './input/gilbert_colorbar.dat';
img_crop = './input/gilbert_figure_6a_crop.png';

% load the datasets
cbar_raw = load(cbardata);
RGBimage = imread(img_crop);

% process the color scale
cbar_regrid = ...
    interp_cbar(cbar_raw, [400, 420], 64);

% preview the cropped image if needed
% impixel(RGBimage);

% launch the gui to collect user data
% set_locations({img_crop});


%% Test the YUV function.

% This will give you an idea how could a color
% be considered "outside of the scale".

% fprintf('Distance between yellow and white:\n');
% RGB_1 = [239, 216, 44]; RGB_2 = [255, 255, 255];
% YUV_dist = uv_distance(RGB_1, RGB_2);
% disp(YUV_dist);
% 
% fprintf('Distance between black and dark blue:\n');
% RGB_1 = [7, 66, 109]; RGB_2 = [3, 43, 124];
% YUV_dist = uv_distance(RGB_1, RGB_2);
% disp(YUV_dist);


%% Perform fuzzy matching.

% specify axis ranges of the real map
% (they must define your cropped image tightly)
X_range = [-119.5, -102];
Y_range = [35.5, 42.5];

% pixels you'd like to skip along each axis
[N_row, N_col, ~] = size(RGBimage);
N_pixels = ceil(N_row / 15);

% report these parameters
fprintf('Image size: %d x %d\n', N_col, N_row);
fprintf('Step size: %d pixels\n', N_pixels);
fprintf('\n');

% examine output directory
outdir = './output/';
if ~exist(outdir, 'dir')
    mkdir(outdir);
end

% traverse through the image
% at a specified step size or user provided data
user_data = true;
[sampled, N_vis, N_exc] = process_img(X_range, Y_range, ...
    N_pixels, RGBimage, cbar_regrid, user_data);


%% Remake for comparison.

% reload the sampled dataset
% (if you do not want to repeat the digitization process)
% sampled = load('./output/digitized.dat');

% you may comment out process_img() so that
% this code block can be executed independently
% (requires cbar_raw, x_range, y_range from above)

% create a dir for saving plots
pltdir = './report/';
if ~exist(pltdir, 'dir')
    mkdir(pltdir);
end

% decide filename to use
if user_data
    filename = 'gilbert_figure_6a_manual.png';
else
    filename = 'gilbert_figure_6a_auto.png';
end

% remake with cbar regrid
remake_cntr(X_range, Y_range, 0.25, ...
    cbar_regrid, sampled, pltdir, filename);

