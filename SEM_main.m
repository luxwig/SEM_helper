function varargout = SEM_main(varargin)
% SEM_MAIN MATLAB code for SEM_main.fig
%      SEM_MAIN, by itself, creates a new SEM_MAIN or raises the existing
%      singleton*.
%
%      H = SEM_MAIN returns the handle to a new SEM_MAIN or the handle to
%      the existing singleton*.
%
%      SEM_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEM_MAIN.M with the given input arguments.
%
%      SEM_MAIN('Property','Value',...) creates a new SEM_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SEM_main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SEM_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SEM_main

% Last Modified by GUIDE v2.5 27-Apr-2018 16:52:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SEM_main_OpeningFcn, ...
                   'gui_OutputFcn',  @SEM_main_OutputFcn, ...
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


% --- Executes just before SEM_main is made visible.
function SEM_main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SEM_main (see VARARGIN)

% Choose default command line output for SEM_main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global dir_current set_dir
set_dir = false;
dir_current = pwd;

% UIWAIT makes SEM_main wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SEM_main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_ok.
function btn_ok_Callback(hObject, eventdata, handles)
    handles.txt_zip.BackgroundColor = [0.94 0.94 0.94];
    handles.txt_imgdir.BackgroundColor = [0.94 0.94 0.94];
    handles.txt_out.BackgroundColor = [0.94 0.94 0.94];
    t = true;
    if exist( handles.txt_zip.String ,'file') == 0
        handles.txt_zip.BackgroundColor = [1 0.6 0.6];
        t = false;
    end
    if exist(handles.txt_imgdir.String,'dir') == 0 
        handles.txt_imgdir.BackgroundColor = [1 0.6 0.6];
        t = false;
    end
    if exist(handles.txt_out.String,'dir')== 0
         handles.txt_out.BackgroundColor = [1 0.6 0.6];
         t = false;
    end
    if t
        uiwait(viewer_gui(@figure1_SizeChangedFcn, ...
            handles.txt_zip.String, ...
            handles.txt_imgdir.String, ...
            handles.txt_out.String));
    end
     

% hObject    handle to btn_ok (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_cancel.
function btn_cancel_Callback(hObject, eventdata, handles)
    close(handles.figure1)
% hObject    handle to btn_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function txt_zip_Callback(hObject, eventdata, handles)
% hObject    handle to txt_zip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_zip as text
%        str2double(get(hObject,'String')) returns contents of txt_zip as a double


% --- Executes during object creation, after setting all properties.
function txt_zip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_zip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_imgdir_Callback(hObject, eventdata, handles)
% hObject    handle to txt_imgdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_imgdir as text
%        str2double(get(hObject,'String')) returns contents of txt_imgdir as a double


% --- Executes during object creation, after setting all properties.
function txt_imgdir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_imgdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function txt_out_Callback(hObject, eventdata, handles)
% hObject    handle to txt_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txt_out as text
%        str2double(get(hObject,'String')) returns contents of txt_out as a double


% --- Executes during object creation, after setting all properties.
function txt_out_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txt_out (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btn_folderls.
function btn_folderls_Callback(hObject, eventdata, handles)
    global dir_current
    dir = dir_current
    if ~isempty(handles.txt_zip.String)
        dir = handles.txt_zip.String;
    end
    [path] = uigetdir(dir);
    if (path ~= 0)
        handles.txt_zip.String = path;
        dir_current = path;
    end
% hObject    handle to btn_folderls (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_img.
function btn_img_Callback(hObject, eventdata, handles)
    global dir_current
    dir = dir_current;
    if ~isempty(handles.txt_imgdir.String)
        dir = handles.txt_imgdir.String;
    end
    [path] = uigetdir(dir);
    if (path ~= 0)

        handles.txt_imgdir.String = path;
        dir_current = path;
    end
% hObject    handle to btn_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_output.
function btn_output_Callback(hObject, eventdata, handles)
    global dir_current
    dir = dir_current;
    if ~isempty(handles.txt_out.String)
        dir = handles.txt_out.String;
    end
    [path] = uigetdir(dir);
    if (path ~= 0)

        handles.txt_out.String = path;
        dir_current = path;
    end
% hObject    handle to btn_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in btn_zip.
function btn_zip_Callback(hObject, eventdata, handles)
% hObject    handle to btn_zip (see GCBO)
    global dir_current
    dir = strcat(dir_current,'/*.zip');
    if ~isempty(handles.txt_zip.String)
        dir = handles.txt_zip.String;
    end
    [file,path] = uigetfile(dir);
    if (path ~= 0)

        handles.txt_zip.String = strcat(path,file);
        dir_current = path;
    end
    
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
