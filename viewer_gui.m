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

% Last Modified by GUIDE v2.5 17-Apr-2018 06:14:56

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
handles.output = hObject;
guidata(hObject, handles);
figure(handles.figure1);
if length(varargin) ~= 4
    error('Wrong number of parameters - autoprobe dir, imshow dir, save dir')
end
global list imshow_list num n_imshow pos pos_current save_dir sel imshow_dir
dir = varargin{2};
imshow_dir = varargin{3};
save_dir = varargin{4};

if exist(dir,'file') == 0 || exist(imshow_dir,'dir') == 0 || exist(save_dir,'dir')== 0
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

if (save_dir(end) ~= '/')
    save_dir = strcat(save_dir,'/');
end
if (imshow_dir(end) ~= '/')
    imshow_dir = strcat(imshow_dir,'/');
end

list = [];
num = 0;
for i = 1:length(fnames)
    [~,fnn,~] = fileparts(fnames{i});
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

%cd(imshow_dir)
imshow_list = ls('-1','-c',strcat(imshow_dir,'*.tif'));
imshow_list = splitlines(imshow_list);
imshow_list = imshow_list(1:end-1);

[n_imshow,~] = size(imshow_list);
imshow_index = zeros(1,n_imshow);
for i = 1:n_imshow
    [~,t,~] = fileparts(imshow_list{i});
    imshow_index(i) = str2double(t(end-2:end));
end
[~,imshow_index] = sort(imshow_index);
imshow_list = imshow_list(imshow_index);

handles.sbar.Max = n_imshow;
handles.sbar.Min = 1;

handles.sbar.SliderStep = [1/(n_imshow-1) 1/(n_imshow-1)];
handles.lbox.String = fns;
pos_current = 1;
if exist(strcat(imshow_dir,'/','result.mat'),'file') == 2
    load(strcat(imshow_dir,'/','result.mat'));
    pos = pos;
    sel = sel;
    loadimshow(handles,pos_current);
else
pos = zeros(1,num);
pos = reposition(pos, 1, 0);
sel = zeros(1,num);
position = (list(1,1)-2)*4 + list(1,2) + 1;
handles.txt_fn.String = imshow_list{position};
handles.sbar.Value = position;
handles.txt_ct.String = getStrID(list(1,:));
imshow(imread(imshow_list{position}));
nx = length(find(sel==1));
str = strcat('Selected: ',num2str(nx),'\n','Current: ',num2str(pos_current),' / ',num2str(length(sel)));
str = compose(str);
handles.txt_status.String = str;
end 








% Update handles structure



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

global imshow_list
val = round(hObject.Value);
hObject.Value = val;
imshow(imread(imshow_list{val}))
handles.txt_fn.String = imshow_list{val};
handles.chk_tmp.Enable = 'on';


% --- Executes during object creation, after setting all properties.
function sbar_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function csvwriteHelper(dir,sel,list)
str = strcat(dir,'/result.csv');
index = find(sel == 1);
fid = fopen(str, 'w+') ;
for i = index
    fprintf(fid, '%d,%s\n', list(i,1),char(list(i,2)+'A')) ;
end
fclose(fid);


% --- Executes on selection change in lbox.
function lbox_Callback(hObject, eventdata, handles)
global pos_current imshow_dir pos sel save_dir list
if updatePos(handles,pos_current)
    pos_current = handles.lbox.Value;
    loadimshow(handles,pos_current);
    save(strcat(imshow_dir,'/result.mat'),'pos','sel')
    csvwriteHelper(save_dir, sel, list)
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
global pos_current pos sel imshow_dir save_dir list
%pos_current = handles.lbox.Value;
if (pos_current == 1) 
    return
end
if updatePos(handles,pos_current)
    pos_current = pos_current - 1;
    loadimshow(handles,pos_current);
end
save(strcat(imshow_dir,'/result.mat'),'pos','sel')
csvwriteHelper(save_dir,sel,list)




% --- Executes on button press in btn_fwd.
function btn_fwd_Callback(hObject, eventdata, handles)
global num pos_current pos sel imshow_dir save_dir list
%pos_current = handles.lbox.Value;
if (pos_current == num) 
    return
end
if updatePos(handles,pos_current)
    pos_current = pos_current + 1;
    loadimshow(handles,pos_current);
end
save(strcat(imshow_dir,'/result.mat'),'pos','sel')
csvwriteHelper(save_dir,sel,list)

% --- Executes on button press in chk_sel.
function chk_sel_Callback(hObject, eventdata, handles)
    str = char(handles.txt_ct.String);
    str = strcat(str(1,:),str(2,:));
    global imshow_list pos pos_current save_dir sel list imshow_dir
    sel(pos_current) = handles.chk_sel.Value;
    [~,imshow_name,~] = fileparts(imshow_list{pos(pos_current)});
    save_fn = strcat(save_dir,'/',imshow_name(1:end-3),'_',str,'.tif');
if handles.chk_sel.Value == 1
    copyfile(handles.txt_fn.String,save_fn)
    
elseif exist(save_fn, 'file') == 2 
    delete(save_fn);
end
nx = length(find(sel==1));
str = strcat('Selected: ',num2str(nx),'\n','Current: ',num2str(pos_current),' / ',num2str(length(sel)));
str = compose(str);
handles.txt_status.String = str;
save(strcat(imshow_dir,'/result.mat'),'pos','sel')
csvwriteHelper(save_dir,sel,list)

    
% hObject    handle to chk_sel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chk_sel

function p = getStdPos(index)
global list
p = (list(index,1)-2)*4 + list(index,2) + 1;

function r = reposition(arr, start_pos, offset)
global n_imshow
r = arr;
for i = start_pos:length(arr)
    r(i) = min(getStdPos(i) + offset,n_imshow);
end

function str = getStrID(p)
str = num2str(p(1,1));
str = compose(strcat(str,'\n',p(1,2)+'A'));

function r = updatePos(handles, pos_current)
global pos num
p_t = handles.sbar.Value;
if pos(pos_current) ~= p_t
    answer = questdlg('Position has changed. Confirm?', 'Reposition Warning','Yes', 'No', 'No');
    if strcmp(answer, 'Yes') == 0
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
 
function loadimshow(handles, pos_current)
global pos imshow_list list sel
handles.chk_tmp.Enable = 'off';
handles.chk_tmp.Value = 0;
handles.chk_sel.Value = 0;
handles.lbox.Value = pos_current;
imshow(imread(imshow_list{pos(pos_current)}))
handles.txt_fn.String = imshow_list{pos(pos_current)};
handles.sbar.Value = pos(pos_current);
handles.txt_ct.String = getStrID(list(pos_current,:));
handles.chk_sel.Value = sel(pos_current);
nx = length(find(sel==1));
str = strcat('Selected: ',num2str(nx),'\n','Current: ',num2str(pos_current),' / ',num2str(length(sel)));
str = compose(str);
handles.txt_status.String = str;


% --- Executes on button press in btn_reset.
function btn_reset_Callback(hObject, eventdata, handles)
global imshow_list list pos_current
handles.chk_tmp.Value = 0;
handles.chk_sel.Value = 0;
%pos_current = handles.lbox.Value;
if getStdPos(pos_current) == handles.sbar.Value
    handles.chk_tmp.Enable = 'off';
else
    handles.chk_tmp.Enable = 'on';
end
imshow(imread(imshow_list{getStdPos(pos_current)}))
handles.txt_fn.String = imshow_list{getStdPos(pos_current)};
handles.sbar.Value = getStdPos(pos_current);
handles.txt_ct.String = getStrID(list(pos_current,:));
% hObject    handle to btn_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_reload.
function btn_reload_Callback(hObject, eventdata, handles)
loadimshow(handles,handles.lbox.Value);
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
    if (strcmp(eventdata.Key, 'shift') == 1)
        global imshow_list pos pos_current
        I = imread(imshow_list{pos(pos_current)});
        imshow(edge(rgb2gray(I),'sobel'))
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


% --- Executes on mouse press over axes background.
function img_dis_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to img_dis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key release with focus on figure1 or any of its controls.
function figure1_WindowKeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)
    if (strcmp(eventdata.Key, 'shift') == 1)
        global imshow_list pos pos_current
        I = imread(imshow_list{pos(pos_current)});
        imshow(I)
    end
