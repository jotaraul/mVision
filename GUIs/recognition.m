function varargout = recognition(varargin)
% RECOGNITION M-file for recognition.fig
%      RECOGNITION, by itself, creates a new RECOGNITION or raises the existing
%      singleton*.
%
%      H = RECOGNITION returns the handle to a new RECOGNITION or the handle to
%      the existing singleton*.
%
%      RECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RECOGNITION.M with the given input arguments.
%
%      RECOGNITION('Property','Value',...) creates a new RECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before recognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to recognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help recognition

% Last Modified by GUIDE v2.5 14-Oct-2017 18:47:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @recognition_OpeningFcn, ...
                   'gui_OutputFcn',  @recognition_OutputFcn, ...
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


% --- Executes just before recognition is made visible.
function recognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to recognition (see VARARGIN)

    % Choose default command line output for recognition
    handles.output = hObject;

    a = imread('white.jpg');
    axes(handles.axes1)
    newHandle = imshow(a);
    set(newHandle,'ButtonDownFcn',{@axes1_ButtonDownFcn,handles});
    axis off;
    
    global userData;
    userData.plots = [];
    userData.xy1 = [];
    userData.xy2 = [];
    userData.objeto = [];
    userData.elipses = [];
    userData.ginputFixer = 0;
    
    % Activamos la opcion de reconocer
    set(handles.text3,'enable','on');
    set(handles.recognitionTypeList,'enable','on'); 
    
    % Update handles structure
    guidata(hObject, handles);

% UIWAIT makes recognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = recognition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in recognitionTypeList.
function recognitionTypeList_Callback(hObject, eventdata, handles)
% hObject    handle to recognitionTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns recognitionTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from recognitionTypeList

    option = get(hObject,'Value');
    
    set(handles.pushbutton1,'Enable','on');
    
    switch option
        
        case 1 % Clasificador bayesiano
            
 
    end
            
    guidata(hObject,handles);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global userData;
    
    % Delete possible ellipses
    delete(userData.elipses);
    userData.elipses = [];
    
    set(handles.info,'String', 'Results are shown on the right.'); 
    
    num1 = size(userData.xy1);
    num2 = size(userData.xy2);
    num3 = size(userData.objeto);
    
    if (num1(2) < 2) || (num2(2) < 2) || (num3(1) == 0)
        set(handles.info,'String', 'Error: The data required for recognition have not been introduced.'); 
    else
        option = get(handles.recognitionTypeList,'Value');
        mahalanobis = get(handles.mahalanobis,'Value');
        euclidea = get(handles.euclidea,'Value');
        ok = 1;

        switch option

            case 1 

               if mahalanobis

                   if num1(2) ~= num2(2)
                      set(handles.info,'String', 'This option requires that both classes have the same number of objects.'); 
                      ok = 0;
                   else    
                       [val,vec,covar] = autovalores([userData.xy1 ; userData.xy2], 0, 1);
                       handle = error_ellipse(covar,mean(userData.xy1,2));
                       userData.elipses = [userData.elipses handle];
                       handle = error_ellipse(covar,mean(userData.xy2,2));
                       userData.elipses = [userData.elipses handle];
                       d1 = evaluarFuncDecision(2,userData.objeto,userData.xy1,covar);
                       d2 = evaluarFuncDecision(2,userData.objeto,userData.xy2,covar);
                       set(handles.covar,'String', {'Covar. matrix',  ['[ ' ...
                           num2str(covar(1,1)), ' ', num2str(covar(1,2)), ' ; ', ...
                           num2str(covar(2,1)), ' ', num2str(covar(2,2)), ' ] '], ...
                           ' ',...
                           'Eigenvalues', ...
                           [ num2str(val(1)), '    ', num2str(val(2)) ]});
                   end

               elseif euclidea               
                   covar = [1 0; 0 1];
                   handle = error_ellipse(covar.*100,mean(userData.xy1,2));
                   userData.elipses = [userData.elipses handle];
                   handle = error_ellipse(covar.*100,mean(userData.xy2,2));
                   userData.elipses = [userData.elipses handle];
                    
                   d1 = evaluarFuncDecision(3,userData.objeto,userData.xy1);
                   d2 = evaluarFuncDecision(3,userData.objeto,userData.xy2);
                   
                       set(handles.covar,'String', {'Covar. matrix',  ['[ ' ...
                           num2str(covar(1,1)), ' ', num2str(covar(1,2)), ' ; ', ...
                           num2str(covar(2,1)), ' ', num2str(covar(2,2)), ' ] '],});
               else

                   [val1,vec1,covar1] = autovalores(userData.xy1,0);
                   handle = error_ellipse(covar1,mean(userData.xy1,2));
                   userData.elipses = [userData.elipses handle];
                   hold on;
                   d1 = evaluarFuncDecision(1,userData.objeto,userData.xy1,covar1,0.5);
                   [val2,vec2,covar2] = autovalores(userData.xy2,0);
                   handle = error_ellipse(covar2,mean(userData.xy2,2));
                   userData.elipses = [userData.elipses handle];
                   d2 = evaluarFuncDecision(1,userData.objeto,userData.xy2,covar2,0.5);
                   
                       set(handles.covar,'String', {'Covar. matrix red class',  ['[ ' ...
                           num2str(covar1(1,1)), ' ', num2str(covar1(1,2)), ' ; ', ...
                           num2str(covar1(2,1)), ' ', num2str(covar1(2,2)), ' ] '], ...
                           'Eigenvalues', ...
                           [ num2str(val1(1)), '    ', num2str(val1(2)) ], ...
                           ' ', ...
                           'Covar. matrix blue class',  ['[ ' ...
                           num2str(covar2(1,1)), ' ', num2str(covar2(1,2)), ' ; ', ...
                           num2str(covar2(2,1)), ' ', num2str(covar2(2,2)), ' ] '], ...
                           'Eigenvalues', ...
                           [ num2str(val2(1)), '    ', num2str(val2(2)) ]});                   
               end

               if ok

                   claseAsignada = 1;
                   if d1 < d2
                       claseAsignada = 2;
                   end

                   clases = ['Red ' ; 'Blue'];
                   set(handles.texto,'String',{'Results of decision functions:',' ' ...
                        ,['d1(x)= ',num2str(d1), '  (Red)'],['d2(x) = ',num2str(d2), '  (Blue)'],' ' ...
                        ['The assigned class is: ',num2str(claseAsignada), ' ', clases(claseAsignada,:)]});
               end
        end

        guidata(hObject,handles);    
    end


    % --------------------------------------------------------------------
function quit_Callback(hObject, eventdata, handles)
% hObject    handle to quit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    opc=questdlg('�Do you quit the program?','QUIT','Yes','No','No');
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


% --- Executes on mouse press over axes background.
function axes2_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    path = get(hObject,'UserData');
    figure(1);
    imshow(path);


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global userData;
    
    if userData.ginputFixer == 0
    
        set(handles.info,'String', {'First class','Left button: Add element to class. Right button: Finish add element to this class.'});    
        set(handles.texto,'String', ' ');
        set(handles.covar,'String', ' ');    

        % Reseteamos por si existen ya algunos puntos
        delete(userData.plots);
        delete(userData.elipses);
        userData.plots = [];
        userData.xy1= [];
        userData.xy2= [];
        userData.objeto= [];
        userData.elipses = [];

        n = 0;
        but = 1; %botton izdo del raton: 2: medio: 3: dcho
        hold on;
        while but == 1
            [xi,yi,but] = ginput(1);
            if but == 1
                userData.plots = [userData.plots plot(xi,yi,'ro')];
                n = n+1;
                userData.xy1(:,n) = [xi;yi];            
            end
            userData.ginputFixer =  userData.ginputFixer +1;
        end

        set(handles.info,'String', {'Second class','Left button: Add element to class. Right button: Finish add element to this class.'});

        n = 0;
        but = 1; %botton izdo del raton: 2: medio: 3: dcho
        while but == 1
            [xi,yi,but] = ginput(1);
            if but == 1
                userData.plots = [userData.plots plot(xi,yi,'bo')];
                n = n+1;
                userData.xy2(:,n) = [xi;yi];
            end
            userData.ginputFixer =  userData.ginputFixer +1;
        end

        set(handles.info,'String', {'Object to recognize','Left or right button: Add object to recognize.'});

        [xi,yi] = ginput(1);
        userData.plots = [userData.plots plot(xi,yi,'mo')];
        userData.objeto = [xi;yi];
        userData.ginputFixer =  userData.ginputFixer +1;

        set(handles.info,'String', 'Push "recognize" button to perform the recognition');
    else
        userData.ginputFixer =  userData.ginputFixer - 1;
    end


% --- Executes on button press in resetear.
function resetear_Callback(hObject, eventdata, handles)
% hObject    handle to resetear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global userData;

    delete(userData.plots);
    delete(userData.elipses);
    userData.plots = [];
    userData.xy1= [];
    userData.xy2= [];
    userData.objeto= [];
    userData.elipses = [];
    set(handles.info,'String', 'Click in the 2D Space to start whit the recognition process');
    set(handles.texto,'String', ' ');
    set(handles.covar,'String', ' ');    


% --- Executes on button press in mahalanobis.
function mahalanobis_Callback(hObject, eventdata, handles)
% hObject    handle to mahalanobis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of mahalanobis
    
    set(handles.euclidea,'Value',0);
    guidata(hObject,handles);   


% --- Executes on button press in euclidea.
function euclidea_Callback(hObject, eventdata, handles)
% hObject    handle to euclidea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of euclidea

    set(handles.mahalanobis,'Value',0);
    guidata(hObject,handles);   


function loadToolbar_ClickedCallback(hObject, eventdata, handles)
    loadImage_Callback(hObject, eventdata, handles);

function saveToolbar_ClickedCallback(hObject, eventdata, handles)
    saveImage_Callback(hObject, eventdata, handles);


% --- Executes on selection change in recognitionTypeList.
function objectRecognitionType_Callback(hObject, eventdata, handles)
% hObject    handle to recognitionTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns recognitionTypeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from recognitionTypeList


% --- Executes during object creation, after setting all properties.
function recognitionTypeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to recognitionTypeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
