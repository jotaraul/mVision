function varargout = edges(varargin)
% EDGES M-file for edges.fig
%      EDGES, by itself, creates a new EDGES or raises the existing
%      singleton*.
%
%      H = EDGES returns the handle to a new EDGES or the handle to
%      the existing singleton*.
%
%      EDGES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDGES.M with the given input arguments.
%
%      EDGES('Property','Value',...) creates a new EDGES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edges_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edges_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edges

% Last Modified by GUIDE v2.5 12-Oct-2017 09:40:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edges_OpeningFcn, ...
                   'gui_OutputFcn',  @edges_OutputFcn, ...
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


% --- Executes just before edges is made visible.
function edges_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edges (see VARARGIN)

    % Choose default command line output for edges
    handles.output = hObject;

    a = imread('imagenNoCargada.jpg');
    axes(handles.axes1)
    imshow(a);
    axis off;
    
    global userData;
    userData.imGrad = [];
    userData.imGradAngulos = [];
    userData.actRow = []; % Para tener solo un vector gradiente dibujado como max
    userData.option = 1;
    userData.ginputFixer = 1;% Needed because ginput fuction re-activate ButtonDownCallback
    
    a = imread('noHayResultados.jpg');
    axes(handles.axes2)
    handleNaxes = imshow(a);
    axis off;
    %setHandleAxes(handleNaxes,'noHayResultados');
    set(handleNaxes,'ButtonDownFcn',@axes2_ButtonDownFcn);
    set(handleNaxes,'UserData',a);

    
    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes edges wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edges_OutputFcn(hObject, eventdata, handles) 
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
        
        %Mostramos la imagen       
        axes(handles.axes1);
        newHandle = imshow(a);
        set(newHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);
        set(newHandle,'UserData',a);
        
        handles.imagenOriginal = a; 
        
        % Activamos la opcion de detectar
        set(handles.text3,'enable','on');
        set(handles.listbox1,'enable','on'); 
        set(handles.text17,'enable','on');
        
        set(handles.pushbutton1,'Enable','on');
    
        set(handles.edit3,'visible','on');
        set(handles.edit4,'visible','off');
        set(handles.edit5,'visible','off');
        set(handles.text4,'visible','on');
        set(handles.text5,'visible','off');
        set(handles.text13,'visible','off');        
            
        set(handles.edit3,'String',num2str(20));
        
        % Desactivamos algun posible resultado
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;               
        
        axes(handles.axes6)
        a = imread('empty.jpg');
        imshow(a);
        axis off;
        handles.imagenVacia = a;
        set(handles.axes6,'Visible','off');
        set(handles.textImagenGradiente,'Visible','off');
        
        userData.actRow = [];
        
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

    global userData;
    userData.option = get(hObject,'Value');
    
    switch userData.option
        
        case 1 % Sobel 3
            
            set(handles.edit3,'visible','on');
            set(handles.edit4,'visible','off');
            set(handles.edit5,'visible','off');
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','off');
            set(handles.text13,'visible','off');
            
            set(handles.edit3,'String',num2str(20));
            
        case 2 % Sobel 5
            
            set(handles.edit3,'visible','on');
            set(handles.edit4,'visible','off');
            set(handles.edit5,'visible','off');
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','off');
            set(handles.text13,'visible','off');
            
            set(handles.edit3,'String',num2str(20));
            
        case 3 % Drog
            
            set(handles.edit3,'visible','on');
            set(handles.edit4,'visible','on');
            set(handles.edit5,'visible','on');
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','on');
            set(handles.text13,'visible','on');
            
            set(handles.edit3,'String',num2str(20));
            
        case 4 % Canny
            
            set(handles.edit3,'visible','on');
            set(handles.edit4,'visible','off');
            set(handles.edit5,'visible','on');
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','off');
            set(handles.text13,'visible','on');
            
            set(handles.edit3,'String',num2str(0.5));
            
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global userData;
    delete(userData.actRow);
    userData.actRow = [];

    option = userData.option;
    
    switch option
        
        case 1 % Sobel 3
           th = str2double(get(handles.edit3,'String'));
           [imRes, imX, imY, imGrad, time] = doSobel(handles.imagenOriginal,th,1); 
           set(handles.textImagenGradiente,'Visible','on');
           
        case 2 % Sobel 5
           th = str2double(get(handles.edit3,'String'));
           [imRes, imX, imY, imGrad, time] = doSobel(handles.imagenOriginal,th,2);
           set(handles.textImagenGradiente,'Visible','on');
           
        case 3 % Drog
           th = str2double(get(handles.edit3,'String'));
           hsize = str2double(get(handles.edit4,'String'));
           sigma = str2double(get(handles.edit5,'String'));
           [imRes, imX, imY, imGrad, time] = doDrog(handles.imagenOriginal, hsize, sigma, th);
           set(handles.textImagenGradiente,'Visible','on');

        case 4 % Canny
           tic;
           th = str2double(get(handles.edit3,'String'));
           sigma = str2double(get(handles.edit5,'String'));
           imRes = edge(handles.imagenOriginal,'canny',th,sigma);
           %[imRes, or] = canny(handles.imagenOriginal, sigma);
           % Desactivamos alguna posible imagen gradiente
           set(handles.textImagenGradiente,'Visible','off');
           imGrad = handles.imagenVacia;
           time = toc;

    end
    
    axes(handles.axes2);
    handleNaxes2 = imshow(imRes);
    set(handleNaxes2,'ButtonDownFcn',@axes2_ButtonDownFcn);
    set(handleNaxes2,'UserData',imRes);
    
    if option ~= 4
        set(handles.axes6,'Visible','on');
        imGradAngulos = atan2(imY,imX);    
        axes(handles.axes6);
        handleNaxes2 = imshow(imGrad);
        axis off;
        userData.imGradAngulos = imGradAngulos; 
    else
        axes(handles.axes6);
        a = imread('empty.jpg');
        imshow(a);
    end
    
    % Si hemos detectado edges con sobel 3 activamos el poder ver la
    % direcci�n y el m�dulo del vector gradiente
    if option == 1
        set(handleNaxes2,'ButtonDownFcn',{@axes3_ButtonDownFcn,handles});
    else
        set(handleNaxes2,'ButtonDownFcn',{@axes2_ButtonDownFcn,handles});
        set(handleNaxes2,'userData',imGrad);
    end

    userData.imGrad = imGrad; 
    
    set(handles.text6,'Visible','on');
    set(handles.text7,'Visible','on');
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

    opc=questdlg('�Do you want quit the program?','QUIT','Yes','No','No');
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
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    showVersion;
    

% Funcion auxiliar
function fileTypes = supportedImageTypes
    % Funci�n auxiliar: formatos de im�genes.
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
    fileTypes = supportedImageTypes; % Funci�n auxiliar.
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


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

    th = str2double(get(hObject,'String'));
    if (isnan(th) || (th < 0))
        errordlg('The value must be numeric and bigger than zero','ERROR')
        set(hObject,'String',20);
    end
    
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

    hsize = str2double(get(hObject,'String'));
    if (isnan(hsize) || (hsize < 0) || ( mod(hsize, 2) == 0))
        errordlg('The value must be numeric and bigger than zero','ERROR')
        set(hObject,'String',5);
    end
    
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

    sigma = str2double(get(hObject,'String'));
    if (isnan(sigma) || (sigma < 0))
        errordlg('The value must be numeric and bigger than zero','ERROR')
        set(hObject,'String',2);
    end
    
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on mouse press over axes background.
function axes3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global userData;
    
    if userData.ginputFixer 
    
        imGradAngulos = userData.imGradAngulos;
        imGrad = userData.imGrad;

        [x,y] = ginput(1);     
        [fil,col] = size(imGradAngulos);
        aux = x;
        x = round(y);
        y = round(aux);
        if x < 1 || x > fil || y < 1 || y > col
            errordlg('Please, click into the image :)','ERROR');
        else
            grados = rad2deg(imGradAngulos(x,y));
            modulo = double(imGrad(x,y)/4);
            if grados == 0 || grados == 180
                newY = y; 
                newX = x +  round(modulo/cosd(grados));
            elseif grados == 90 || grados == -90
                newY = y + round(modulo/sind(grados));
                newX = x;
            else
                newX = x +  round(modulo/cosd(grados));
                newY = y +  round(modulo/sind(grados));
            end

            delete(userData.actRow);        
            userData.actRow = line([y newY],[x newX],'Marker','<');

        end
        userData.ginputFixer = 0;
    else
        userData.ginputFixer = 1;
    end


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    path = get(hObject,'UserData');
    figure(1);
    imshow(path);


% --------------------------------------------------------------------
function loadFromClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to loadFromClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    global imCortapapeles;
    global imCortaExist;
    
    if imCortaExist
        
        handles.imagenOriginal = imCortapapeles;
        %Mostramos la imagen       
        axes(handles.axes1);
        newHandle = imshow(handles.imagenOriginal);
        set(newHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);
        set(newHandle,'UserData',handles.imagenOriginal);

        % Activamos la opcion de detectar
        set(handles.text3,'enable','on');
        set(handles.listbox1,'enable','on'); 
        set(handles.pushbutton1,'enable','on');
        set(handles.text17,'enable','on');

        % Desactivamos algun posible resultado
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;               

        axes(handles.axes6)
        a = imread('empty.jpg');
        imshow(a);
        axis off;
        handles.imagenVacia = a;
        set(handles.axes6,'Visible','off');
        set(handles.textImagenGradiente,'Visible','off');
        
    else
        errordlg('There is no image in the clipboard','ERROR')
    end

    guidata(hObject,handles);
    
    
% --------------------------------------------------------------------
function saveToClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to saveToClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global imCortapapeles;
    imCortapapeles = handles.imagenResultado;
    global imCortaExist;
    imCortaExist = 1;


% --------------------------------------------------------------------
function loadToolbar_ClickedCallback(hObject, eventdata, handles)
    loadImage_Callback(hObject, eventdata, handles);
    


% --------------------------------------------------------------------
function saveToolbar_ClickedCallback(hObject, eventdata, handles)
    saveImage_Callback(hObject, eventdata, handles);
