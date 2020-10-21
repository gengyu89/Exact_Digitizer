function remake_cntr(X_range, Y_range, ...
    dl, cbar_regrid, sampled, pltdir, filename)
%REMAKE_CNTR Subroutine for replotting the remade
%   contour map and saving it.
% 
% X_RANGE, Y_RANGE, DL
%   - these must be provided manually considering that
%   the sampled points cannot define the original map
%   (usually smaller than that range)
% 


%% Manipulate dataset.

% split data into vectors
sampled_x = sampled(:,1);
sampled_y = sampled(:,2);
sampled_v = sampled(:,3);

% calculate new axes and prepare meshgrids
grid_x = X_range(1) : dl : X_range(2);
grid_y = Y_range(1) : dl : Y_range(2);
[X, Y] = meshgrid(grid_x, grid_y);

% create interpolant
Fv = scatteredInterpolant(sampled_x, sampled_y, ...
    sampled_v, 'natural', 'none');  % use 'nearest' or 'none' for extrapolation
Cv = Fv(X(:,:,1), Y(:,:,1));


%% Start plotting stuffs.

% create a new window
fig = figure;

% specify colormap
cmap = cbar_regrid(:,2:4) / 255;
colormap(cmap);

% for scattered data
size = 25;
darkgray = [0.5, 0.5, 0.5];

disp('Remaking...');

% plot major components
hold on
pcolor(X, Y, Cv);
scatter(sampled_x, sampled_y, size, 'kx');
borders('continental us', 'nomap', 'k-.', ...
    'HandleVisibility', 'off');
hold off

% label the plot
% xlabel('longitude (degrees)');
% ylabel('latitude (degrees)');

% manipulate axes
axis('equal');
xlim(X_range);  % if 'tight' is not specified
ylim(Y_range);  % please provide xlim and ylim

% display a colorbar
% at the bottom of the plot
cb = colorbar('Location', 'eastoutside');
title(cb, 'km');

% minor styling adjustments
shading interp; box on;

% save the plot
fullpath = [pltdir, filename];
saveas(fig, fullpath);
fprintf('Done. File saved as: %s\n', fullpath);
fprintf('\n');


end

