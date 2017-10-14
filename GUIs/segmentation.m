function varargout = segmentation(varargin)
% SEGMENTATION M-file for segmentation.fig
%      SEGMENTATION, by itself, creates a new SEGMENTATION or raises the existing
%      singleton*.
%
%      H = SEGMENTATION returns the handle to a new SEGMENTATION or the handle to
%      the existing singleton*.
%
%      SEGMENTATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SEGMENTATION.M with the given input arguments.
%
%      SEGMENTATION('Property','Value',...) creates a new SEGMENTATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before segmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to segmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help segmentation

% Last Modified by GUIDE v2.5 14-Oct-2017 17:40:13

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @segmentation_OpeningFcn, ...
                       'gui_OutputFcn',  @segmentation_OutputFcn, ...
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


% --- Executes just before segmentation is made visible.
function segmentation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to segmentation (see VARARGIN)

    global userData;
    
    userData.plots.centroide = [];
    userData.plots.autovectores = [];
    userData.imagenResultado = [];
    userData.ginputFixer = 0;

    % Choose default command line output for segmentation
    handles.output = hObject;

    a = imread('imagenNoCargada.jpg');
    axes(handles.axes1)
    imshow(a);
    axis off;

    a = imread('noHayResultados.jpg');
    axes(handles.axes2);
    imshow(a);
    axis off;    
    
    %borrarResultados(handles);
    
    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes segmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = segmentation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --------------------------------------------------------------------
function loadImage_Callback(hObject, eventdata, handles)
% hObject    handle to loadImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global imOrigHandle;
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
        
        handles.imagenOriginal = a; 
       
        option = get(handles.segmentationTypeList,'Value');
        
        if option == 2
            [fil,col] = size(handles.imagenOriginal);
            set(handles.text20,'String',['Tam Img: ', num2str(fil), 'x', num2str(col)]);
        end
        
        %Mostramos la imagen       
        axes(handles.axes1);
        newHandle = imshow(a);
        set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
        set(newHandle,'UserData',a);
        imOrigHandle = newHandle;
        
        % Activamos la opcion de detectar
        set(handles.text3,'enable','on');
        set(handles.segmentationTypeList,'enable','on'); 
        set(handles.text22,'enable','on');
        
        % Eliminamos algun posible plot de centroide y autovectores
        delete(userData.plots.centroide);
        delete(userData.plots.autovectores);
        delete(userData.imagenResultado);
        
        userData.plots.centroide = [];
        userData.plots.autovectores = [];
        userData.imagenResultado = [];
        
        % Desactivamos algun posible resultado
        a = imread('noHayResultados.jpg');
        b = imread('empty.jpg');
        
        axes(handles.axes2);
        hold off;
        imshow(a);
        axis off;
        
        borrarResultados(handles);        
        
        axes(handles.axes11);
        imshow(b);
        axis off;
        
        % Active thresholding ilumination demo
        set(handles.text21,'Enable','on');
        set(handles.pushbutton2,'Enable','on');        

    end
    
    handles.direccion = strcat(Path,FileName);
    guidata(hObject,handles);


% --- Executes on selection change in segmentationTypeList.
function segmentationTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to segmentationTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns segmentationTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from segmentationTypeList

    global imOrigHandle;
    
    inf=get(hObject,'Value');
    
    set(handles.pushbutton1,'Enable','on');
    
    switch inf
        
        case 1 % Hough rectas
            
            set(imOrigHandle,'ButtonDownFcn',@axes1_ButtonDownFcn); 
            
            % Activamos las acciones propias
            set(handles.edit3,'visible','on');
            set(handles.edit4,'visible','on');
            set(handles.edit5,'visible','on');
            set(handles.edit6,'visible','on');
            
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','on');            
            set(handles.text13,'visible','on');
            set(handles.text20,'visible','on');
            
            set(handles.text4,'String','Edges threshold');
            set(handles.text5,'String','Votes threshold');
            set(handles.text13,'String','Tita variation');
            set(handles.text20,'String','Local max range');
            
            set(handles.edit3,'String','20');
            set(handles.edit4,'String','5');
            set(handles.edit5,'String','20');
            
        case 2 % Crecimiento de regiones
            
            set(imOrigHandle,'ButtonDownFcn',{@axes2_ButtonDownFcn,handles});
            
            % Activamos las opciones propias
            set(handles.edit3,'visible','on');
            set(handles.edit4,'visible','on');
            set(handles.edit5,'visible','on');

            set(handles.text4,'visible','on');
            set(handles.text5,'visible','on');
            set(handles.text13,'visible','on');
            set(handles.text20,'visible','on');
            
            set(handles.text4,'String','Seed x');
            set(handles.text5,'String','Seed y');
            set(handles.text13,'String','Gray tone variation');
            [fil,col] = size(handles.imagenOriginal);
            set(handles.text20,'String',['Tam Img: ', num2str(fil), 'x', num2str(col)]);
            
            set(handles.edit3,'String','1');
            set(handles.edit4,'String','1');
            set(handles.edit5,'String','10');
            
            % Desactivamos el resto de opciones
            set(handles.edit6,'visible','off');
        
        case 3 % Hough circulos
            
            set(imOrigHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
            
            % Activamos las acciones propias
            set(handles.edit3,'visible','on');
            set(handles.edit4,'visible','on');
            
            set(handles.text4,'visible','on');
            set(handles.text5,'visible','on');            
            
            set(handles.text4,'String','Edges threshold');
            set(handles.text5,'String','Circles radius');
            
            set(handles.edit3,'String','100');
            set(handles.edit4,'String','20');
            
            % Desactivamos no usadas
            set(handles.edit5,'visible','off');
            set(handles.edit6,'visible','off');
            
            set(handles.text13,'visible','off');
            set(handles.text20,'visible','off');
    end
            
    guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function segmentationTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to segmentationTypeList (see GCBO)
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
    
    option = get(handles.segmentationTypeList,'Value');
    
    switch option
        
        case 1
            
            tic;
            
            th1 = str2double(get(handles.edit3,'String'));
            th2 = str2double(get(handles.edit4,'String'));
            see = str2double(get(handles.edit5,'String'));
            seeLocalMax = str2double(get(handles.edit6,'String'));
            % Llamamos la detector de bordes
            [imRes, imX, imY, imGrad] = doSobel(handles.imagenOriginal,th1,1);
            [fil,col] = size(imRes);
            tau = round(sqrt((fil^2)+(col^2)));
            % Detectamos las rectas
            [imRes2,imVotos,imRectas] = houghRect(imRes,imX,imY,tau,-90, ...
                                               180,th2,0.5,see,seeLocalMax);
            time = toc;
           
            % Activamos todos los axes y textos
            
            set(handles.axes6,'Visible','on');
            set(handles.axes8,'Visible','on');
            set(handles.axes10,'Visible','on');
            set(handles.axes11,'Visible','on');
            set(handles.text14,'Visible','on');   
            set(handles.text17,'Visible','on'); 
            set(handles.text18,'Visible','on'); 
            set(handles.text19,'Visible','on'); 
            
            set(handles.text2,'String','Edges image');

            % Mostramos la imagen bordes
            axes(handles.axes2);
            newHandle = imshow(imRes);
            set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(newHandle,'UserData',imRes);  

            % Mostramos la imagen de votos
            axes(handles.axes6);
            handleImVotos = imshow(imVotos); 
            set(handleImVotos,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(handleImVotos,'UserData',imVotos);

            % Mostramos la imagen gradiente
            axes(handles.axes8);
            newHandle = imshow(imGrad);                    
            set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(newHandle,'UserData',imGrad);  

            % Mostramos la imagen resultado 
            axes(handles.axes11);
            newHandle = imshow(imRes2);
            set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(newHandle,'UserData',imRes2);  

            % Mostramos la imagen de rectas
            axes(handles.axes10);
            newHandle = imshow(imRectas);
            set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
        	set(newHandle,'UserData',imRectas);  
            
        case 2 % Crecimiento de regiones
            
            delete(userData.plots.autovectores);
            delete(userData.plots.centroide);
            delete(userData.imagenResultado);
            
            tic;
            
            x = str2double(get(handles.edit3,'String'));
            y = str2double(get(handles.edit4,'String'));
            variation = str2double(get(handles.edit5,'String'));
            
            [imRes, time] = seed(handles.imagenOriginal,x,y,variation);
            
 
            time = toc;
            
            % Mostramos la imagen bordes
            axes(handles.axes2);
            newHandle = imshow(imRes);
            set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(newHandle,'UserData',imRes);  
            
            userData.imagenResultado = newHandle;
            
            [x,y] = find(imRes==0);

            hold on;
            
            [val,vect] = autovalores([y';x'],0);
            
            userData.plots.centroide = plot(mean(y),mean(x),'ro');
            userData.plots.autovectores = ...
                plot(mean(y) + [0 val(1)*vect(1,1)], mean(x) +[0 val(1)*vect(2,1)], ...
                mean(y) + [0 val(2)*vect(1,2)], mean(x) +[0 val(2)*vect(2,2)]);
            
            set(handles.text2,'String','Result image');
            borrarResultados(handles);

        case 3            
      
            tic;
            
            th1 = str2double(get(handles.edit3,'String'));
            radio = str2double(get(handles.edit4,'String'));

            % Llamamos al detector de bordes
            [imRes, imX, imY, imGrad] = doSobel(handles.imagenOriginal,th1,1);

            % Detectamos los círculos
            imVotos = hough_circulos(handles.imagenOriginal,imRes,radio,imGrad,imX,imY,handles.axes11);
            
            time = toc;

            % Activamos todos los axes y textos
            
            set(handles.axes6,'Visible','on');
            set(handles.axes8,'Visible','on');
            set(handles.axes10,'Visible','off');
            set(handles.axes11,'Visible','off');
            set(handles.text14,'Visible','on');   
            set(handles.text17,'Visible','off'); 
            set(handles.text18,'Visible','off'); 
            set(handles.text19,'Visible','on'); 
            
            set(handles.text2,'String','Edges image');

            % Mostramos la imagen bordes
            axes(handles.axes2);
            newHandle = imshow(imRes);
            set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(newHandle,'UserData',imRes);  

            % Mostramos la imagen de votos
            axes(handles.axes6);
            handleImVotos = imshow(imVotos); 
            set(handleImVotos,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(handleImVotos,'UserData',imVotos);

            % Mostramos la imagen gradiente
            axes(handles.axes8);
            newHandle = imshow(imGrad);                    
            set(newHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
            set(newHandle,'UserData',imGrad);  
            
            figure(1);
 
    end
    
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

    opc=questdlg('¿Do you want quit the program?','SALIR','Yes','No','No');
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
    if (isnan(th) || (th < 1))
        errordlg('The value must be numeric and bigger than 0','ERROR')
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

    th = str2double(get(hObject,'String'));
    if (isnan(th) || (th < 1))
        errordlg('The value must be numeric and bigger than 0','ERROR')
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

    see = str2double(get(hObject,'String'));
    if (isnan(see) || (see < 1))
        errordlg('The value must be numeric and bigger than 0','ERROR')
        set(hObject,'String',20);
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
function axes8_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    zoom on;
    zoom(0.1);



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double

    see = str2double(get(hObject,'String'));
    if (isnan(see) || (see < 0))
        errordlg('The value must be numeric and positive','ERROR')
        set(hObject,'String',2);
    end
    
    guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    path = get(hObject,'UserData');
    figure(1);
    imshow(path);
    
% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global userData;
    
    if userData.ginputFixer == 0
        [x,y] = ginput(1);
        [fil,col] = size(handles.imagenOriginal);
        if x < 1 || x > col || y < 1 || y > fil
            errordlg('Rango de las dimensiones de la imagen excedido','ERROR')
        else
            set(handles.edit3,'String',num2str(round(x)));
            set(handles.edit4,'String',num2str(round(y)));
        end
        userData.ginputFixer = 1;
    else 
        userData.ginputFixer = 0;
    end
        

    


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
function loadFromClipboard_Callback(hObject, eventdata, handles)
% hObject    handle to loadFromClipboard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global imCortapapeles;
    global imCortaExist;
    global imOrigHandle;
    
    if imCortaExist
        
        handles.imagenOriginal = imCortapapeles;
       
        set(handles.pushbutton1,'Enable','on');
        
        option = get(handles.segmentationTypeList,'Value');
        
        switch option
            case 1

                % Activamos las acciones propias
                set(handles.edit3,'visible','on');
                set(handles.edit4,'visible','on');
                set(handles.edit5,'visible','on');
                set(handles.edit6,'visible','on');

                set(handles.text4,'visible','on');
                set(handles.text5,'visible','on');            
                set(handles.text13,'visible','on');
                set(handles.text20,'visible','on');

                set(handles.text4,'String','Edges threshold');
                set(handles.text5,'String','Votes threshold');
                set(handles.text13,'String','Tita variation');
                set(handles.text20,'String','Local max range');

                set(handles.edit3,'String','20');
                set(handles.edit4,'String','5');
                set(handles.edit5,'String','20');

            case 2

                % Activamos las opciones propias
                set(handles.edit3,'visible','on');
                set(handles.edit4,'visible','on');
                set(handles.edit5,'visible','on');

                set(handles.text4,'visible','on');
                set(handles.text5,'visible','on');
                set(handles.text13,'visible','on');
                set(handles.text20,'visible','on');

                set(handles.text4,'String','Seed x');
                set(handles.text5,'String','Seed y');
                set(handles.text13,'String','Gray tone variation');
                [fil,col] = size(handles.imagenOriginal);
                set(handles.text20,'String',['Tam Img: ', num2str(fil), 'x', num2str(col)]);

                set(handles.edit3,'String','1');
                set(handles.edit4,'String','1');
                set(handles.edit5,'String','10');

                % Desactivamos el resto de opciones
                set(handles.edit6,'visible','off');

        end
        
        %Mostramos la imagen       
        axes(handles.axes1);
        imOrigHandle = imshow(handles.imagenOriginal);
        set(imOrigHandle,'UserData',handles.imagenOriginal);

        if option == 1
            set(imOrigHandle,'ButtonDownFcn',@axes1_ButtonDownFcn);
        elseif option == 2
            set(imOrigHandle,'ButtonDownFcn',@axes2_ButtonDownFcn);      
        end
        
        % Activamos la opcion de detectar
        set(handles.text3,'enable','on');
        set(handles.segmentationTypeList,'enable','on'); 
        
        % Active thresholding ilumination demo
        set(handles.text21,'Enable','on');
        set(handles.pushbutton2,'Enable','on');
        
        % Desactivamos algun posible resultado
        a = imread('noHayResultados.jpg');
        axes(handles.axes2)
        imshow(a);
        axis off;
        

        
        
        borrarResultados(handles);

        
    else
        errordlg('No hay ninguna imagen guardada en el cortapapeles','ERROR')
    end

    guidata(hObject,handles);


function borrarResultados(handles)

    imagenVacia = imread('empty.jpg');
    handles.imagenVacia = imagenVacia;
    axes(handles.axes6);
    imshow(imagenVacia);
    axes(handles.axes8);
    imshow(imagenVacia);
    axes(handles.axes10);
    imshow(imagenVacia);
    axes(handles.axes11);
    imshow(imagenVacia);
    set(handles.text14,'Visible','off');   
    set(handles.text17,'Visible','off'); 
    set(handles.text18,'Visible','off'); 
    set(handles.text19,'Visible','off');
    
        


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    im1 = handles.imagenOriginal;
    [fil,col] = size(im1);
    
    %Calculamos el fondo de la imagen
    bg32=blkproc(im1,[32,32],'min(x(:))'); %fondo de bloques de 32x32 (imagen 8x8)
    bg256=imresize(bg32,[fil,col],'bicubic'); %se iterpola la imagen de 8x8 para obtener una de 256x256

    %Se lo quitamos a la imagen original y la realzamos para reestablecer el brillo y contraste
    dif=double(im1)-double(bg256); %
    dif_realzada=imadjust(uint8(dif),[0 max(dif(:))]./255,[0 1],1); %La realzamos. OJO: hay que dividir por 255 para que este en el rango[0 1]

    %Lo dibujamos todo
    figure
    subplot(2,3,1), imshow(im1), title('Original image')
    subplot(2,3,4), imhist(im1); title('Histogram of original image')

    subplot(2,3,2), imshow(uint8(dif)); title('Difference image')
    subplot(2,3,5), imshow(bg256); title('Background image') 

    subplot(2,3,3), imshow(uint8(dif_realzada)); title('Dif. im. enhanced')
    subplot(2,3,6), imhist(uint8(dif_realzada)); title('Histo dif. im. enhanced')


function openToolbar_ClickedCallback(hObject, eventdata, handles)
    loadImage_Callback(hObject, eventdata, handles);


function saveToolbar_ClickedCallback(hObject, eventdata, handles)
    saveImage_Callback(hObject, eventdata, handles);
