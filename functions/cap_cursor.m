function [xcap, ycap] = cap_cursor(handles)
%CAP_CURSOR Subroutine for capturing user inputs
%   via the mouse cursor and plotting on top of an image.
% 
% handles - used to show
%   captured data with mouse clicks
% 


% pre allocate structures
xcap = []; ycap = [];

% parameters for symbols
blue = [0 0.4470 0.7410]; white = [1 1 1];
size_1 = 36; size_2 = 25;

% refresh the table content
% (sometimes this may help with debugging)
set(handles.uitable1, 'Data', []);  % release the selected cell
table_data = [handles.xcap, handles.ycap];
set(handles.uitable1, 'Data', table_data);

% Do not use [NaN, NaN] to release the selected cell
% The 'Reset' button will not show the effect immediately

% display the image and all captured data
refresh_axes(handles, size_1, size_2, blue, white);

hold on
while true
    
    % capture the location
    [xi, yi, but] = ginput(1);
    if ~isequal(but, 1)
        break
    end
    xcap = [xcap; ceil(xi)];
    ycap = [ycap; ceil(yi)];
    
    % refresh the image during each iteration
    imshow(handles.path);
    xdata = [handles.xcap; xcap];
    ydata = [handles.ycap; ycap];
    scatter(xdata, ydata, size_1,  blue, 'filled');
    scatter(xdata, ydata, size_2, white, 'filled');
    table_data = [xdata, ydata];
    set(handles.uitable1, 'Data', table_data);
end
hold off

% Notes taken for view_grids.m:
%   1.8, '.' and 3.6, 'filled'
%   roughly have the same size

% save the modified handles
% guidata(hObject, handles)
% for some reason
% you cannot save the data here


end

