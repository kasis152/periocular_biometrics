function varargout = UI_front_page2(varargin)
%clear all;

% UI_FRONT_PAGE2 MATLAB code for UI_front_page2.fig
%      UI_FRONT_PAGE2, by itself, creates a new UI_FRONT_PAGE2 or raises the existing
%      singleton*.
%
%      H = UI_FRONT_PAGE2 returns the handle to a new UI_FRONT_PAGE2 or the handle to
%      the existing singleton*.
%
%      UI_FRONT_PAGE2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI_FRONT_PAGE2.M with the given input arguments.
%
%      UI_FRONT_PAGE2('Property','Value',...) creates a new UI_FRONT_PAGE2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_front_page2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_front_page2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI_front_page2

% Last Modified by GUIDE v2.5 20-Feb-2018 02:02:55

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_front_page2_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_front_page2_OutputFcn, ...
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


% --- Executes just before UI_front_page2 is made visible.
function UI_front_page2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI_front_page2 (see VARARGIN)

% Choose default command line output for UI_front_page2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


[filename pathname] = uigetfile({'*.jpg';'*.bmp'},'File Selector');
global pic1; 
pic1 = strcat(pathname, filename);
global pic12;
pic12=imread(pic1);
pic12=imresize(pic12,[227 227]);
axes(handles.axes1);
imshow(pic12);

%figure;
%imshow(pic1);
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
detector.MergeThreshold = 10;
global bbox;
 bbox = step(EyeDetect,pic12);
size(bbox);
global out;
 out = insertObjectAnnotation(pic12,'rectangle',bbox,'');
%x = bbox(1);
%y = bbox(2);
%w = bbox(3);
%h = bbox(4);

axes(handles.axes3);
imshow(out);

axes(handles.axes2);
imshow(imcrop(pic12,bbox));
% --- Executes on button press in pushbutton1.


% UIWAIT makes UI_front_page2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_front_page2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
%net1=load ('C:\Users\Aman Jain\netfinal');
%load netFinal;
global netfinal;
global pic12;
predictedLabels = classify(netfinal,pic12);
disp(predictedLabels);
o=string(predictedLabels);
j=" ";
b="the person name is "
i=strcat(b,j);
i=strcat(i,o);
set(handles.edit1,'String',i);


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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
