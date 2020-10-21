function refresh_axes(handles, size_1, size_2, color_1, color_2)
%REFRESH_AXES Subroutine for replacing the axes
%   with the current captured data.


% replace the current image being displayed
imshow(handles.path);

% plot all captured data
hold on
scatter(handles.xcap, handles.ycap, size_1, color_1, 'filled');
scatter(handles.xcap, handles.ycap, size_2, color_2, 'filled');
hold off


end

