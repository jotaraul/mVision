function varargout = enhancement(varargin)
% ENHANCEMENT M-file for enhancement.fig
%      ENHANCEMENT, by itself, creates a new ENHANCEMENT or raises the existing
%      singleton*.
%
%      H = ENHANCEMENT returns the handle to a new ENHANCEMENT or the handle to
%      the existing singleton*.
%
%      ENHANCEMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ENHANCEMENT.M with the given input arguments.
%
%      ENHANCEMENT('Property','Value',...) creates a new ENHANCEMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before enhancement_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to enhancement_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help enhancement

% Last Modified by GUIDE v2.5 04-Mar-2010 20:02:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @enhancement_OpeningFcn, ...
                   'gui_OutputFcn',  @enhancement_OutputFcn, ...
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


% --- Executes just before enhancement is made visible.
function enhancement_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to enhancement (see VARARGIN)

    global userData;
    userData.actPlot = [];

    % Choose default command line output for enhancement
    handles.output = hObject;

    a = imread('imagenNoCargada.jpg');
    axes(handles.axes1)
    imshow(a);
    axis off;

    a = imread('noHayResultados.jpg');
    axes(handles.axes2)
    imshow(a);
    axis off;    
    
    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes enhancement wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = enhancement_OutputFcn(hObject, eventdata, handles) 
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

    global userData;

    [FileName Path]=uigetfile({'*.jpg;*.bmp;*.tif'},'Cargar Imagen');
    
    if isequal(FileName,0)
        return
    else
        % Cargamos la imagen
        [a, map] = imread(strcat(Path,FileName));
        
        % La convertimos a escala de grises si procede
        info = imfinfo(strcat(Path,FileName));
    
        if ( strcmp(info.ColorType,'truecolor') )        
            a = rgb2gray(a);
        elseif ( strcmp(info.ColorType,'indexed') )
            a = ind2gray(a,map);
        end
        
        %Mostramos la imagen y su histograma        
        axes(handles.axes1);
        newHandle = imshow(a);
        set(newHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);
        set(newHandle,'UserData',a);  
        
        set(handles.text11,'Visible','on');
        set(handles.axes3,'Visible','on');
        axes(handles.axes3);        
        imhist(a);
        
        handles.imagenOriginal = a;
        
        % Activamos la opcion de realzar y la transformación de la paleta
        set(handles.text3,'enable','on');
        set(handles.listbox1,'enable','on'); 
        
        set(handles.pushbutton1,'Enable','on');
        
        option = get(handles.listbox1,'Value');
    
        switch option
        
            case 1            
                % Activamos las opciones de la transformacion de la paleta
                set(handles.slider1,'visible','on');
                set(handles.slider2,'visible','on');
                set(handles.text4,'visible','on');
                set(handles.text5,'visible','on');
                set(handles.text9,'visible','on');
                set(handles.text10,'visible','on');

                % Desactivamos el resto de opciones

            case 2     
                % Activamos las opciones de la igualación del histograma

                % Desactivamos el resto de opciones
                set(handles.slider1,'visible','off');
                set(handles.slider2,'visible','off');
                set(handles.text4,'visible','off');
                set(handles.text5,'visible','off');
                set(handles.text9,'visible','off');
                set(handles.text10,'visible','off');

        end
        
        % Desactivamos algun posible resultado y su histograma
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;        
        
        set(handles.text12,'Visible','off');
        set(handles.axes4,'Visible','off');  
        set(handles.axes5,'Visible','off');  
        
        delete(userData.actPlot);
        
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

    option = get(hObject,'Value');
    
    switch option
        
        case 1            
            % Activamos las opciones de la transformacion de la paleta
            set(handles.slider1,'visible','on');
            set(handles.slider2,'visible','on');
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','on');
            set(handles.text9,'visible','on');
            set(handles.text10,'visible','on');
            
            % Desactivamos el resto de opciones
            
        case 2     
            % Activamos las opciones de la igualación del histograma
            
            % Desactivamos el resto de opciones
            set(handles.slider1,'visible','off');
            set(handles.slider2,'visible','off');
            set(handles.text4,'visible','off');
            set(handles.text5,'visible','off');
            set(handles.text9,'visible','off');
            set(handles.text10,'visible','off');
            
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
        errordlg('The value must be numeric, bigger than 1 and odd','ERROR')
        set(hObject,'String',3);
        set(hObject,'Value',3);
    else
        set(hObject,'Value',hsize);
    end
    
    guidata(hObject, handles);
    

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

    sigma = str2double(get(hObject,'String'));
    if (isnan(sigma) || (sigma < 1))
        errordlg('The value must be numeric and bigger than 1','ERROR')
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

    global userData;

    option = get(handles.listbox1,'Value');
    
    switch option
        
        case 1 % Transformación de la paleta
            
            min = floor(get(handles.slider1,'Value'));
            max = floor(get(handles.slider2,'Value'));
            [imRes, time, tabla] = paletteTransformation(handles.imagenOriginal,min,max);          
            
            axes(handles.axes5);
            userData.actPlot = plot((1:1:256),tabla);
            set(handles.axes5,'Visible','on');
            
        case 2 % Igualación de histograma
            tic;
            [imRes] = histeq(handles.imagenOriginal);
            hold off;
            axes(handles.axes5);
            userData.actPlot = plot(0,0);
            time = toc;
    end
    
    axes(handles.axes2);
    newHandle = imshow(imRes);
    set(newHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);
    set(newHandle,'UserData',imRes);        
    
    axes(handles.axes4);
    imhist(imRes);
    
    set(handles.axes4,'Visible','on');
    set(handles.text7,'Visible','on');
    set(handles.text6,'Visible','on');
    set(handles.text12,'Visible','on');
    set(handles.text7,'String',time);
    
    handles.imagenResultado = imRes;
    
    guidata(hObject,handles);
    


% --- Executes during object creation, after setting all properties.
function pushbutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


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


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function About_Callback(hObject, eventdata, handles)
% hObject    handle to About (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
    msgbox(['Imagen guardada en ' fName], 'Guardar imagen');


% --------------------------------------------------------------------
function opciones_Callback(hObject, eventdata, handles)
% hObject    handle to opciones (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    suavizado();


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    min = get(hObject,'Value');
    set(handles.text9,'String',floor(min));
    guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

    max = get(hObject,'Value');
    set(handles.text10,'String',floor(max));
    guidata(hObject,handles);
    

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function copyToClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to copyToClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global imCortapapeles;
    imCortapapeles = handles.imagenResultado;
    global imCortaExist;
    imCortaExist = 1;
    
    
% --------------------------------------------------------------------
function loadFromClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to loadFromClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global imCortapapeles;
    global imCortaExist;
    
    if imCortaExist
        
        handles.imagenOriginal = imCortapapeles;
        
        %Mostramos la imagen y su histograma        
        axes(handles.axes1);
        newHandle = imshow(handles.imagenOriginal);
        set(newHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);
        set(newHandle,'UserData',handles.imagenOriginal);  
        
        set(handles.text11,'Visible','on');
        set(handles.axes3,'Visible','on');
        axes(handles.axes3);        
        imhist(handles.imagenOriginal);
        
        % Activamos la opcion de realzar
        set(handles.text3,'enable','on');
        set(handles.listbox1,'enable','on'); 
        set(handles.pushbutton1,'enable','on');
        
        % Desactivamos algun posible resultado y su histograma
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;        
        
        set(handles.text12,'Visible','off');
        set(handles.axes4,'Visible','off');  
        set(handles.axes5,'Visible','off');  
        
        option = get(handles.listbox1,'Value');
    
        switch option
        
            case 1            
                % Activamos las opciones de la transformacion de la paleta
                set(handles.slider1,'visible','on');
                set(handles.slider2,'visible','on');
                set(handles.text4,'visible','on');
                set(handles.text5,'visible','on');
                set(handles.text9,'visible','on');
                set(handles.text10,'visible','on');

                % Desactivamos el resto de opciones

            case 2     
                % Activamos las opciones de la igualación del histograma

                % Desactivamos el resto de opciones
                set(handles.slider1,'visible','off');
                set(handles.slider2,'visible','off');
                set(handles.text4,'visible','off');
                set(handles.text5,'visible','off');
                set(handles.text9,'visible','off');
                set(handles.text10,'visible','off');

        end

        
    else
        errordlg('No hay ninguna imagen guardada en el cortapapeles','ERROR')
    end

    guidata(hObject,handles);


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    path = get(hObject,'UserData');
    figure(1);
    imshow(path);
    


function openToolbar_ClickedCallback(hObject, eventdata, handles)
    loadImage_Callback(hObject, eventdata, handles);


function saveToolbar_ClickedCallback(hObject, eventdata, handles)
    saveImage_Callback(hObject, eventdata, handles);

