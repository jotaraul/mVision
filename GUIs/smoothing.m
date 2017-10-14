function varargout = smoothing(varargin)
% SMOOTHING M-file for smoothing.fig
%      SMOOTHING, by itself, creates a new SMOOTHING or raises the existing
%      singleton*.
%
%      H = SMOOTHING returns the handle to a new SMOOTHING or the handle to
%      the existing singleton*.
%
%      SMOOTHING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SMOOTHING.M with the given input arguments.
%
%      SMOOTHING('Property','Value',...) creates a new SMOOTHING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before smoothing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to smoothing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help smoothing

% Last Modified by GUIDE v2.5 11-Oct-2017 16:37:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @smoothing_OpeningFcn, ...
                   'gui_OutputFcn',  @smoothing_OutputFcn, ...
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


% --- Executes just before smoothing is made visible.
function smoothing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to smoothing (see VARARGIN)

    % Choose default command line output for smoothing
    handles.output = hObject;

    %Show initial images
    a = imread('imagenNoCargada.jpg');
    axes(handles.axes1)
    imshow(a);
    axis off;

    a = imread('noHayResultados.jpg');
    axes(handles.axes2)
    imshow(a);
    axis off;    
    
    handles.imagenResultado = [];
    
    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes smoothing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = smoothing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --------------------------------------------------------------------
function file_Callback(hObject, eventdata, handles)
% hObject    handle to file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function loadImage_Callback(hObject, eventdata, handles)
% hObject    handle to loadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    % Obtain filename and path of the image to load
    [FileName Path] = uigetfile({'*.jpg;*.bmp;*.tif'},'Cargar Imagen');
    
    % Check is FileName is empty
    if isequal(FileName,0)
        return
    else
        % Load image
        [a, map] = imread(strcat(Path,FileName));
        
        % Convert image to grayscale if not
        info = imfinfo(strcat(Path,FileName));
    
        if ( strcmp(info.ColorType,'truecolor') )        
            a = rgb2gray(a);
        elseif ( strcmp(info.ColorType,'indexed') )
            a = ind2gray(a,map);
        end
        
        % Show image
        axes(handles.axes1);
        newHandle = imshow(a);
        handles.imagenOriginal = a; 
        set(newHandle,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});
        
        % Update labels
        set(handles.text3,'enable','on');
        set(handles.listbox1,'enable','on');       
        
        % Enable smoothing button
        set(handles.pushbutton1,'Enable','on');
        set(handles.text4,'visible','on');
        set(handles.edit1,'visible','on');
        
    end

    handles.direccion = strcat(Path,FileName);
    guidata(hObject,handles);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1

    inf = get(hObject,'Value');
    
    switch inf
        
        case 1 % Promediado del entorno
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','off');
            set(handles.edit1,'visible','on');
            set(handles.edit2,'visible','off');
            set(handles.pushbutton2,'Visible','off');
            
        case 2 % Filtro Gaussiano           
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','on');
            set(handles.edit1,'visible','on');
            set(handles.edit2,'visible','on');
            set(handles.pushbutton2,'Visible','on');
            
        case 3 % Mediana
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','off');
            set(handles.edit1,'visible','on');
            set(handles.edit2,'visible','off');
            set(handles.pushbutton2,'Visible','off');
            
    end
            
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
    
    hsize = str2double(get(hObject,'String'));
    if (isnan(hsize) || (hsize < 1) || (mod(hsize,2) == 0))
        errordlg('Value must be numeric, bigger than 1 and odd','ERROR')
        set(hObject,'String',3);
        set(hObject,'Value',3);
    else
        set(hObject,'Value',hsize);
    end
    
    guidata(hObject, handles);
    

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

    sigma = str2double(get(hObject,'String'));
    if (isnan(sigma) || (sigma < 1))
        errordlg('Value must be numeric and bigger than 1','ERROR')
        set(hObject,'String',1);
        set(hObject,'Value',1);
    else
        set(hObject,'Value',sigma);
    end
    
    guidata(hObject, handles);


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
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    option = get(handles.listbox1,'Value');
    
    set(handles.text13,'String','Working ...');
    pause(1/2);
    
    switch option
        case 1
            hsize = get(handles.edit1,'Value');
            [imRes, time] = averagedEnvironment(handles.imagenOriginal,hsize);
        case 2
            hsize = get(handles.edit1,'Value');
            sigma = get(handles.edit2,'Value');
            [imRes, time, mask] = gaussFilter(handles.imagenOriginal,sigma,hsize,1);
            handles.mascara = mask;
            set(handles.pushbutton2,'enable','on');
        case 3
            hsize = get(handles.edit1,'Value');
            [imRes, time] = medianFilter(handles.imagenOriginal,hsize);            
    end
    
    axes(handles.axes2);
    newHandle = imshow(imRes);
    handles.imagenResultado = imRes;
    set(newHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);
    set(newHandle,'UserData',imRes);
    
    set(handles.text6,'Visible','on');
    set(handles.text7,'Visible','on');
    set(handles.text13,'String','');
    set(handles.text7,'String',time);
    
    guidata(hObject,handles);    

    
% --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    opc=questdlg('¿Do you want quit the program?','QUIT','Yes','No','No');
    if strcmp(opc,'No')
        return;
    end
    clear,clc,close all


function about_Callback(hObject, eventdata, handles)

    showVersion;
    
    
% Funcion auxiliar
function fileTypes = supportedImageTypes
    % Función auxiliar: formatos de imágenes.
    fileTypes = {'*.jpg','JPEG (*.jpg)';'*.tif','TIFF (*.tif)';...
                '*.bmp','Bitmap (*.bmp)';'*.*','All files (*.*)'};


% --------------------------------------------------------------------
function saveImage_Callback(hObject, eventdata, handles)
% hObject    handle to saveImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    imRes = handles.imagenResultado;
    if isempty(imRes), return, end
    
    %guardar como file
    fileTypes = supportedImageTypes; % Función auxiliar.
    [f,p] = uiputfile(fileTypes);
    
    if f==0, return, end
    
    fName = fullfile(p,f);
    imwrite(imRes,fName);
    msgbox(['Image saved in ' fName], 'Save image');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    mascara = handles.mascara


% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function ayuda_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function copyClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to copyClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global imCortapapeles;
    imCortapapeles = handles.imagenResultado;
    global imCortaExist;
    imCortaExist = 1;


% --------------------------------------------------------------------
function loadClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to loadClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global imCortaExist;
    global imCortapapeles;
    
    if imCortaExist
        
        handles.imagenOriginal = imCortapapeles;
        %Mostramos la imagen       
        axes(handles.axes1);
        newHandle = imshow(handles.imagenOriginal);
        set(newHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);
        set(newHandle,'UserData',handles.imagenOriginal);

        % Activamos la opcion de suavizar
        set(handles.pushbutton1,'enable','on');
        set(handles.text3,'enable','on');
        set(handles.listbox1,'enable','on'); 
        set(handles.text4,'visible','on');
        set(handles.edit1,'visible','on');
        set(handles.listbox1, 'value', 1);
        
        % Desactivamos algun posible resultado
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;      
        
    else
        errordlg('No image saved on the clipboard','ERROR')
    end
    
     guidata(hObject,handles);   


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    path = get(hObject,'UserData');
    figure(2);
    imshow(path);


function axes1_ButtonDownFcn(hObject, eventdata, handles)

    figure(1);
    imshow(handles.imagenOriginal);


function openToolbar_ClickedCallback(hObject, eventdata, handles)
    loadImage_Callback(hObject, eventdata, handles);


function saveToolbar_ClickedCallback(hObject, eventdata, handles)
    saveImage_Callback(hObject, eventdata, handles);
