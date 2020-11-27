function varargout = UI_front_page(varargin)
% UI_FRONT_PAGE MATLAB code for UI_front_page.fig
%      UI_FRONT_PAGE, by itself, creates a new UI_FRONT_PAGE or raises the existing
%      singleton*.
%
%      H = UI_FRONT_PAGE returns the handle to a new UI_FRONT_PAGE or the handle to
%      the existing singleton*.
%
%      UI_FRONT_PAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI_FRONT_PAGE.M with the given input arguments.
%
%      UI_FRONT_PAGE('Property','Value',...) creates a new UI_FRONT_PAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UI_front_page_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UI_front_page_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UI_front_page

% Last Modified by GUIDE v2.5 17-Feb-2018 16:27:01
%disp(r+"aman ");
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UI_front_page_OpeningFcn, ...
                   'gui_OutputFcn',  @UI_front_page_OutputFcn, ...
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


% --- Executes just before UI_front_page is made visible.
function UI_front_page_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UI_front_page (see VARARGIN)

% Choose default command line output for UI_front_page
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
a=imread('IMG6.jpg');
axes(handles.axes1);
imshow(a);
% UIWAIT makes UI_front_page wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UI_front_page_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
r=uigetdir();

images = imageDatastore(r,...
    'IncludeSubfolders',true,...
   'LabelSource','foldernames');
%v=ReadSize(images);
%
n=numel(images.Labels);
m=numel((countEachLabel(images)));
%m=m{1,1};
m=m/2;
%n=ReadSize(images);
for i = 1:n
    
    a=imread((images.Files{i,1}));  
    axes(handles.axes2);
    imshow(a);
detector = vision.CascadeObjectDetector;
detector.MergeThreshold = 5;
bbox = step(detector,a);
size(bbox);
out = insertObjectAnnotation(a,'rectangle',bbox,'');

axes(handles.axes12);
    imshow(out);

  axes(handles.axes14);
    
 %   imshow(imcrop(pic1,bbox))
    imshow(imcrop(a,bbox));
    a=imcrop(a,bbox);
         a=imresize(a,[227 227]);
    imwrite(a,images.Files{i,1});

    pause(0.0010000); 
end
net=alexnet;
% layer = 'fc7';

[trainingImages,testImages] = splitEachLabel(images,0.7,'randomized');
numTrainImages = numel(trainingImages.Labels);

%trainingFeatures = activations(net,trainingImages,layer);
%testFeatures = activations(net,testImages,layer);
trainingLabels = trainingImages.Labels;
testLabels = testImages.Labels;
layersTransfer=net.Layers(1:end-3);
layers = [layersTransfer,
    fullyConnectedLayer(m,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20),
    softmaxLayer,
    classificationLayer]

%set(handles.textMyOutput,'string',num2str(1));
options = trainingOptions('sgdm',...
    'MiniBatchSize',5,...
    'MaxEpochs',10,...
   'InitialLearnRate',0.0001);


netfinal1 = trainNetwork(trainingImages,layers,options);

%%
% Classify the test images using |classify|.
predictedLabels = classify(netfinal,testImages);

%classifier = fitcecoc(trainingFeatures,trainingLabels);
%predictedLabels = predict(classifier,testFeatures);
%for i = 1:numamel(idx)
 %   subplot(2,2,i)
  %  I = readimage(testIm
%  ages,idx(i));
   % label = predictedLabels(idx(i));
    %imshow(I)
    %title(char(label))
%end
accuracy = mean(predictedLabels == testLabels);
global netfinal1;
save netfinal1;
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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
%function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
