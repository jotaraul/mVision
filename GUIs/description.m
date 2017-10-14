function varargout = description(varargin)
% DESCRIPTION M-file for description.fig
%      DESCRIPTION, by itself, creates a new DESCRIPTION or raises the existing
%      singleton*.
%
%      H = DESCRIPTION returns the handle to a new DESCRIPTION or the handle to
%      the existing singleton*.
%
%      DESCRIPTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DESCRIPTION.M with the given input arguments.
%
%      DESCRIPTION('Property','Value',...) creates a new DESCRIPTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before description_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to description_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help description

% Last Modified by GUIDE v2.5 14-Oct-2017 18:06:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @description_OpeningFcn, ...
                   'gui_OutputFcn',  @description_OutputFcn, ...
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


% --- Executes just before description is made visible.
function description_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to description (see VARARGIN)

    % Choose default command line output for description
    handles.output = hObject;
    
    global userData;
    userData.imagenOriginal = [];
    userData.imagenRecortada = [];
    userData.ginputFixer = 0;
    
    % Mostramos las imagenes iniciales
    a = imread('imagenNoCargada.jpg');
    axes(handles.axes1)
    imshow(a);
    axis off;
    
    a = imread('noHayResultados.jpg');
    axes(handles.axes2);
    imshow(a);
    axis off;    
    
    axes(handles.axes3);
    imshow(a);
    axis off;    

    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes description wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = description_OutputFcn(hObject, eventdata, handles) 
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
            a = Ind2Gray(a,map);
        end
        
        %Mostramos la imagen       
        axes(handles.axes1);
        handleImgOrig = imshow(a);
        set(handleImgOrig,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});
        set(handleImgOrig,'UserData',a);
        
        userData.imagenOriginal = a; 
        
        % Activamos la opcion de ejecutar
        set(handles.text18,'enable','on');
        set(handles.text3,'enable','on');
        set(handles.descriptionTypeList,'enable','on');
        set(handles.pushbutton1,'enable','on');
        
        % Desactivamos algun posible resultado
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;               
        
        axes(handles.axes3)
        imshow(a);
        axis off;
        
        set(handles.estado,'String','First, crop a region of the image please');
        
    end

    guidata(hObject,handles);


function descriptionTypeList_Callback(hObject, eventdata, handles)

    option = get(hObject,'Value');
    
    switch option
        
        case 1 % Adelgazamiento
            
        case 2 % Correlacion
            
    end
            
    guidata(hObject,handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global userData;

    option = get(handles.descriptionTypeList,'Value');
    
    switch option
        
        case 1 % adelgazamiento
            
            tic;
            imRes = veradel(userData.imagenRecortada); 
            time = toc;   
        
        case 2 % correlacion
            
            tic;
            imRes = normxcorr2(userData.imagenRecortada(:,:,1), ...
                                userData.imagenOriginal(:,:,1));
            time = toc;
            figure(1);
            surf(imRes); 
            shading flat;
            
    end
    
    % Mostramos el resultado obtenido
    axes(handles.axes3);
    handleNaxes2 = imshow(imRes);
    set(handleNaxes2,'ButtonDownFcn',@axes2_ButtonDownFcn);
    set(handleNaxes2,'UserData',imRes);
    axis off;

    % Ponemos el tiempo de procesamiento
    set(handles.text6,'Visible','on');
    set(handles.text7,'Visible','on');
    set(handles.text7,'String',time);
     
    handles.imagenResultado = imRes;
    
    figure(1);
   
    guidata(hObject,handles);    


function quit_Callback(hObject, eventdata, handles)

    opc=questdlg('Do you want quit the program?','SALIR','Si','No','No');
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
        errordlg('The value must be numeric and greater than zero','ERROR')
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
        errordlg('The value must be numeric and greater than zero','ERROR')
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
        errordlg('The value must be numeric and greater than zero','ERROR')
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
    
    imGradAngulos = userData.imGradAngulos;
    imGrad = userData.imGrad;
    [x,y] = ginput(1);
    [fil,col] = size(imGradAngulos);
    aux = x;
    x = round(y);
    y = round(aux);
    if x < 1 || x > fil || y < 1 || y > col
        errordlg('Range dimension of the image exceeded','ERROR')
    else
        equis = x
        ygriega = y
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
        
        line([y newY],[x newX],'Marker','<')
           
    end

            
function axes1_ButtonDownFcn(hObject, eventdata, handles)

    global userData;
    
    if userData.ginputFixer == 0
    
        axes(handles.axes1);
        set(handles.estado,'String','Click on the upper left corner');

        [x1,y1] = ginput(1);
        x1 = round(x1);
        y1 = round(y1);
        [fil,col] = size(userData.imagenOriginal);
        if x1 < 1 || x1 > col || y1 < 1 || y1 > fil
            errordlg('Range dimension of the image exceeded','ERROR')
        end

        set(handles.estado,'String','Click on the bottom right corner');

        [x2,y2] = ginput(1);
        x2 = round(x2);
        y2 = round(y2);
        if x2 < 1 || x2 > col || y2 < 1 || y2 > fil
            errordlg('Range dimension of the image exceeded','ERROR')
        end

        im_recortada = userData.imagenOriginal(y1:y2,x1:x2);
        option = get(handles.descriptionTypeList,'Value');
        if (option==1)
            im_recortada_bin = im2bw(im_recortada,0.5);
        else
            im_recortada_bin = im_recortada;
        end
        axes(handles.axes2);
        handleNaxes = imshow(im_recortada_bin);
        set(handleNaxes,'ButtonDownFcn',@axes2_ButtonDownFcn);
        set(handleNaxes,'UserData',im_recortada_bin);
        userData.imagenRecortada = im_recortada_bin;

        set(handles.estado,'String',' ');

        % Activamos la opción de ejecutar
        set(handles.pushbutton1,'Enable','on');
        
        userData.ginputFixer = 1;
    elseif userData.ginputFixer == 1
        userData.ginputFixer = 2;
    else 
        userData.ginputFixer = 0;
    end


function axes2_ButtonDownFcn(hObject, eventdata, handles)

    path = get(hObject,'UserData');
    figure(1);
    imshow(path);


function loadFromClipboard_Callback(hObject, eventdata, handles)
    
    global imCortapapeles;
    global imCortaExist;
    global userData;
    
    if imCortaExist
        
        handles.imagenOriginal = imCortapapeles;
        userData.imagenOriginal = imCortapapeles; 
        %Mostramos la imagen       
        axes(handles.axes1);
        newHandle = imshow(handles.imagenOriginal);
        set(newHandle,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});
        set(newHandle,'UserData',handles.imagenOriginal);

        % Activamos la opcion de detectar
        set(handles.text3,'enable','on');
        set(handles.descriptionTypeList,'enable','on'); 
        set(handles.pushbutton1,'enable','on');

        % Desactivamos algun posible resultado
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;               

        axes(handles.axes3)
        a = imread('empty.jpg');
        imshow(a);
        axis off;
        handles.imagenVacia = a;
        set(handles.axes3,'Visible','off');
        set(handles.textImagenGradiente,'Visible','off');
        
    else
        errordlg('No hay ninguna imagen guardada en el cortapapeles','ERROR')
    end

    guidata(hObject,handles);
    
    

function saveToClipboard_Callback(hObject, eventdata, handles)

    global imCortapapeles;
    imCortapapeles = handles.imagenResultado;
    global imCortaExist;
    imCortaExist = 1;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    
    figure(1);
    axis([0 10 0 10])
    hold on
    % Lista de puntos
    xy = [];
    n = 0;
    % Bucle de captura de puntos.
    disp('Boton IZQUIERDO raton para coger puntos')
    disp('Boton DERECHO para terminar')
    but = 1; %botton izdo del raton: 2: medio: 3: dcho
    while but == 1
        [xi,yi,but] = ginput(1);
        plot(xi,yi,'ro')
        n = n+1;
        xy(:,n) = [xi;yi];
    end

    %Ajustamos la recta por el metodo de AJUSTE TOTAL (distancias perpendiculares)
    xmean=mean(xy(1,:));
    ymean=mean(xy(2,:));
    dx=xy(1,:)-xmean;
    dy=xy(2,:)-ymean;
    D=[dx',dy'];
    md=D'*D;%matriz dispersion 2x2
    %tambien asi: md = [dx*dx' dx*dy'; dy*dx' dy*dy' ];
    [U S V]=svd(md); %S matriz diagonal, U matriz con autovectores

    %Dibujamos
    e=3; %longitud recta
    plot(xmean,ymean,'bo')%Punto del centro
    line([xmean-e*U(1,1) xmean+e*U(1,1)],[ymean-e*U(2,1) ymean+e*U(2,1)],'Marker','.','LineStyle','-')%eje del menor autovalor (escalado por 2)


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
% hObject    handle to help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function openToolbar_ClickedCallback(hObject, eventdata, handles)
    loadImage_Callback(hObject, eventdata, handles);


function saveToolbar_ClickedCallback(hObject, eventdata, handles)
    saveImage_Callback(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function descriptionTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descriptionTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
