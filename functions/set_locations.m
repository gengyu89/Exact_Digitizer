function varargout = set_locations(varargin)
% SET_LOCATIONS MATLAB code for set_locations.fig
%      SET_LOCATIONS, by itself, creates a new SET_LOCATIONS or raises the existing
%      singleton*.
%
%      H = SET_LOCATIONS returns the handle to a new SET_LOCATIONS or the handle to
%      the existing singleton*.
%
%      SET_LOCATIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SET_LOCATIONS.M with the given input arguments.
%
%      SET_LOCATIONS('Property','Value',...) creates a new SET_LOCATIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before set_locations_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to set_locations_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help set_locations

% Last Modified by GUIDE v2.5 20-Oct-2020 13:11:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @set_locations_OpeningFcn, ...
                   'gui_OutputFcn',  @set_locations_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before set_locations is made visible.
function set_locations_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to set_locations (see VARARGIN)

% disp(varargin{1});  % must be a cell array

% initialize data fields
handles.path = char(varargin{1});  % string() is not right
handles.xcap = [];
handles.ycap = [];
handles.selectedRows = [];

% update the browsing bar
edit1_Callback(hObject, eventdata, handles);

% display the image and start capturing
imshow(handles.path);
[xcap, ycap] = cap_cursor(handles);
handles.xcap = xcap;
handles.ycap = ycap;

% Choose default command line output for set_locations
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes set_locations wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = set_locations_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% For some reason, you have to use it here:
uiwait(handles.figure1);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% get the current file path
newValue = handles.path;

% update the edit text field
set(handles.edit1, 'String', newValue);


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in 'Browse'.
function pushbutton0_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% supported file types
filter_lst = {'*.bmp'; '*.gif'; ...
    '*.jpg'; '*.jpeg'; '*.png'; ...
    '*.tif'; '*.tiff'; '*.*'};

% pop up a file browser
dialog_box = 'Select an Image';
[file, path] = uigetfile({'*.*'}, dialog_box);

% perform the same behavior as the 'Reset' button
if isequal(file, 0)
    warning('No file selected.');
else
    handles.path = fullfile(path, file);         % update the file path
    edit1_Callback(hObject, eventdata, handles); % update the string field
    pushbutton1_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in 'Reset'.
% --- Used by 'Browse'. Do not change the function name!
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% erase the captured data
handles.xcap = [];
handles.ycap = [];

% start over
imshow(handles.path);
[xcap, ycap] = cap_cursor(handles);
handles.xcap = xcap;
handles.ycap = ycap;

% save the modified handles
guidata(hObject, handles)


% --- Executes on button press in 'Continue'.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% define the 'continue' behavior
[xcap, ycap] = cap_cursor(handles);
handles.xcap = [handles.xcap; xcap];
handles.ycap = [handles.ycap; ycap];

% save the modified handles
guidata(hObject, handles)


% --- Executes on button press in 'Load'.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pop up a file browser
dialog_box = 'Select Your Data';
[file, path] = uigetfile({'*.*'}, dialog_box);

% parameters for symbols
blue = [0 0.4470 0.7410]; white = [1 1 1];
size_1 = 36; size_2 = 25;

if isequal(file, 0)
    warning('No file selected.');
else
    % retrieve from previous work
    fullpath = fullfile(path, file);
    new_data = load(fullpath);
    % append data to the table
    table_dat = get(handles.uitable1, 'Data');
    table_dat = [table_dat; new_data];
    set(handles.uitable1, 'Data', table_dat);
    % update captured data
    xdat = new_data(:,1); ydat = new_data(:,2);
    handles.xcap = [handles.xcap; xdat];
    handles.ycap = [handles.ycap; ydat];
    % refresh the figure
    refresh_axes(handles, size_1, size_2, blue, white);
    % save the modified handles
    guidata(hObject, handles);
    % fprintf('Reloaded data have been added');
    % fprintf(' to the current workspace.\n\n');
end


% --- Executes on button press in 'Save'.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% pop up a file browser
dialog_box = 'Save Your Data';
[file, path] = uiputfile('*.*', dialog_box, 'locations.dat');

% start writing data
if isequal(file, 0)
    warning('No file saved.');
else
    fullpath = fullfile(path, file);
    fp = fopen(fullpath, 'w');
    mat = [handles.xcap, handles.ycap];
    fprintf(fp, '%6d%5d\n', mat.');
    fclose(fp);
    
    fprintf('File saved as:\n');
    fprintf('%s\n\n', fullpath);
end


% --- Executes on button press in 'Delete'.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get the selected rows and table data
rows = handles.selectedRows;
data = get(handles.uitable1, 'Data');

% remove from the bottom
for r = sort(rows, 'descend')
    data(r,:) = [];
    handles.xcap(r) = [];
    handles.ycap(r) = [];
end

% release the selection by updating the table
set(handles.uitable1, 'Data', data);

% Once you do this, handles.selectedRows will be
% automatically updated by uitable1_CellSelectionCallback().

% display the updated image
size_1 = 36; size_2 = 25;
blue = [0 0.4470 0.7410]; white = [1 1 1];
refresh_axes(handles, size_1, size_2, blue, white);

% save the modified handles
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% initialize parameters
size_1 = 36; size_2 = 25;

% get the selected row(s)
rows = unique(eventdata.Indices(:,1));
handles.selectedRows = rows;
xsel = handles.xcap(rows);
ysel = handles.ycap(rows);  % note that eventdata.Indice is immutable

% introduce 2014b colors
blue = [0 0.4470 0.7410]; white = [1 1 1];
yellow = [0.9290 0.6940 0.1250];
orange = [0.8500 0.3250 0.0980];

% display the image
imshow(handles.path);

% replot all data points
hold on
scatter(handles.xcap, handles.ycap, size_1,  blue, 'filled');
scatter(handles.xcap, handles.ycap, size_2, white, 'filled');
hold off

% label the selected ones
hold on
scatter(xsel, ysel, size_1, yellow, 'filled');
scatter(xsel, ysel, size_2, orange, 'filled');
hold off

% save the modified handles
guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
