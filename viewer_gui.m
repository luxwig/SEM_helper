function varargout = viewer_gui(varargin)
% VIEWER_GUI MATLAB code for viewer_gui.fig
%      VIEWER_GUI, by itself, creates a new VIEWER_GUI or raises the existing
%      singleton*.
%
%      H = VIEWER_GUI returns the handle to a new VIEWER_GUI or the handle to
%      the existing singleton*.
%
%      VIEWER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIEWER_GUI.M with the given input arguments.
%
%      VIEWER_GUI('Property','Value',...) creates a new VIEWER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before viewer_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to viewer_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help viewer_gui

% Last Modified by GUIDE v2.5 17-Apr-2018 01:41:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @viewer_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @viewer_gui_OutputFcn, ...
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


% --- Executes just before viewer_gui is made visible.
function viewer_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to viewer_gui (see VARARGIN)
if length(varargin) ~= 3
    error('Wrong number of parameters - autoprobe dir, image dir, save dir')
end
global list image_list num n_image pos pos_current save_dir
dir = varargin{1};
image_dir = varargin{2};
save_dir = varargin{3};

if exist(dir,'file') == 0 || exist(image_dir,'dir') == 0 || exist(save_dir,'dir')== 0
    error('At least one of the folders does not exist')
end

if exist(dir,'file') == 2
    fnames = unzip(dir,'./~output');
    rmdir('./~output','s')
else
    fnames = ls(dir);
    fnames = replace(fnames, char(9), ' ');
    fnames = replace(fnames, char(10), ' ');
    fnames = strsplit(fnames,' ');
end
fns = {};

[save_dir, ~, ~] = fileparts(strcat(save_dir, '/'));
list = [];
num = 0;
for i = 1:length(fnames)
    [~,fnn,] = fileparts(fnames{i});
    if  ~isempty(str2double(fnn(1:end-1))) && ...
        ~isnan(str2double(fnn(1:end-1)))
        num = num + 1;
        list(num,1) = str2double(fnn(1:end-1));
        list(num,2) = fnn(end)-'A';
        fns{num} = fnn;
    end
end
[list, ind] = sortrows(list);
fns = fns(ind);
list = list(5:end,:);
fns = fns(5:end);
num = num-4;

pos = zeros(1,num);

pos = reposition(pos, 1, 0);


cd(image_dir)
image_list = ls('-1','-c',strcat(image_dir,'*.tif'));
image_list = splitlines(image_list);
image_list = image_list(1:end-1);

[n_image,~] = size(image_list);

handles.output = hObject;
handles.sbar.Max = n_image;
handles.sbar.Min = 1;

handles.sbar.SliderStep = [1/(n_image-1) 1/(n_image-1)];
% Update handles structure

position = (list(1,1)-2)*4 + list(1,2) + 1;
handles.lbox.String = fns;
handles.txt_fn.String = image_list{position};
handles.sbar.Value = position;
handles.txt_ct.String = getStrID(list(1,:));
image(imread(image_list{position}));
pos_current = 1;
guidata(hObject, handles);

% UIWAIT makes viewer_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = viewer_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function sbar_Callback(hObject, eventdata, handles)

global image_list
val = round(hObject.Value);
hObject.Value = val;
image(imread(image_list{val}))
handles.txt_fn.String = image_list{val};
handles.chk_tmp.Enable = 'on';


% --- Executes during object creation, after setting all properties.
function sbar_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in lbox.
function lbox_Callback(hObject, eventdata, handles)
global pos_current
if updatePos(handles,pos_current)
    pos_current = handles.lbox.Value;
    loadImage(handles,pos_current);
else
    handles.lbox.Value = pos_current;
end
% hObject    handle to lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns lbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from lbox


% --- Executes during object creation, after setting all properties.
function lbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in chk_tmp.
function chk_tmp_Callback(hObject, eventdata, handles)
% hObject    handle to chk_tmp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_tmp


% --- Executes on button press in btn_bkwd.
function btn_bkwd_Callback(hObject, eventdata, handles)
global pos_current
%pos_current = handles.lbox.Value;
if (pos_current == 1) 
    return
end
if updatePos(handles,pos_current)
    pos_current = pos_current - 1;
    loadImage(handles,pos_current);
end




% --- Executes on button press in btn_fwd.
function btn_fwd_Callback(hObject, eventdata, handles)
global num pos_current
%pos_current = handles.lbox.Value;
if (pos_current == num) 
    return
end
if updatePos(handles,pos_current)
    pos_current = pos_current + 1;
    loadImage(handles,pos_current);
end


% --- Executes on button press in chk_sel.
function chk_sel_Callback(hObject, eventdata, handles)
    str = handles.txt_ct.String';
    str = str(1:end);
    global image_list pos pos_current save_dir
    [~,image_name,~] = fileparts(image_list{pos(pos_current)});
    save_fn = strcat(save_dir,'/',image_name(1:end-3),'_',str,'.tif');
if handles.chk_sel.Value == 1
    copyfile(handles.txt_fn.String,save_fn)
    
elseif exist(save_fn, 'file') == 2 
    delete(save_fn);
end
    
% hObject    handle to chk_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_sel

function p = getStdPos(index)
global list
p = (list(index,1)-2)*4 + list(index,2) + 1;

function r = reposition(arr, start_pos, offset)
global n_image
r = arr;
for i = start_pos:length(arr)
    r(i) = min(getStdPos(i) + offset,n_image);
end

function str = getStrID(p)
str = num2str(p(1,1));
str = compose(strcat(str,'\n',p(1,2)+'A'));

function r = updatePos(handles, pos_current)
global pos num
p_t = handles.sbar.Value;
if pos(pos_current) ~= p_t
    answer = questdlg('Position has changed. Confirm?', 'Reposition Warning','Yes', 'No', 'No');
    if strcmp(answer, 'No') == 1
        r = false;
        return
    end
    if handles.chk_tmp.Value == 1
        pos(pos_current) = p_t;
    elseif pos_current ~= num
        pos = reposition(pos, pos_current, p_t-getStdPos(pos_current));
    end
end
r = true;
 
function loadImage(handles, pos_current)
global pos image_list list
handles.chk_tmp.Enable = 'off';
handles.chk_tmp.Value = 0;
handles.chk_sel.Value = 0;
handles.lbox.Value = pos_current;
image(imread(image_list{pos(pos_current)}))
handles.txt_fn.String = image_list{pos(pos_current)};
handles.sbar.Value = pos(pos_current);
handles.txt_ct.String = getStrID(list(pos_current,:));


% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
global pos image_list list pos_current
handles.chk_tmp.Value = 0;
handles.chk_sel.Value = 0;
%pos_current = handles.lbox.Value;
if getStdPos(pos_current) == handles.sbar.Value
    handles.chk_tmp.Enable = 'off';
else
    handles.chk_tmp.Enable = 'on';
end
image(imread(image_list{getStdPos(pos_current)}))
handles.txt_fn.String = image_list{getStdPos(pos_current)};
handles.sbar.Value = getStdPos(pos_current);
handles.txt_ct.String = getStrID(list(pos_current,:));
% hObject    handle to btn_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
loadImage(handles,handles.lbox.Value);
% hObject    handle to btn_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
    if (strcmp(eventdata.Key, 'uparrow') == 1)
        btn_bkwd_Callback(hObject, eventdata, handles)
    elseif strcmp(eventdata.Key, 'downarrow') == 1
        btn_fwd_Callback(hObject, eventdata, handles)
    end
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when figure1 is resized.
function figure1_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
