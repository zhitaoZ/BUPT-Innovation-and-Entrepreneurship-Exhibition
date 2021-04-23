function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 06-Nov-2020 18:17:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, ~, handles, varargin)
%这个函数下的所有语句都在窗口打开前执行
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)
%%
%添加背景图片
% ha=axes('units','normalized','position',[0 0 1 1]);
% uistack(ha,'down')
% II=imread('background.jpg');
% image(II)
% % colormap gray
% set(ha,'handlevisibility','off','visible','off');
%%
%这里添加axes1的背景图，需要关闭图片的坐标轴并重新插入一个坐标轴
pos=get(handles.axes1, 'pos');%得到背景图区域坐标
axes('pos',pos,'visible','off');%设定画图区域
II=imread('4.PNG');%读取图片
imagesc(II)%显示图片
alpha(0.2)%背景图虚化
hold on%背景图停留
colormap gray%变成灰度图
axis off;%关闭坐标轴
set(handles.axes1,'Xlim',[0 50],'Ylim',[0 30]);%添加坐标范围
set(handles.axes1,'XTick',0:5:50);%添加刻度线
set(handles.axes1,'TickDir','in');%设置刻度线朝向
%%
%这里添加里一个图片，校徽
% im = imread('school_badge.jpg');
% axes(handles.axes2)
% imshow(im)
% set(handles.axes2,'Color',[0.94,0.94,0.94]);
%%
% Choose default command line output for test
handles.output = hObject;
%%
%这里添加按钮的背景图片
% A=imread('background.jpg'); 
% set(handles.StartBtn,'CData',A);
%%
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(~, ~, handles) 
%这个函数下的所有语句都在窗口打开前执行
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%
%按钮的回调函数
function StartBtn_Callback(~, ~, handles)
global M
global num
global a
a=zeros(5,6);
num=1;
for i=1:10
    try
     [data1,data2,data3,data4,data5,data6,data7,data8]=textread('C:\Users\VLC\Desktop\zzt\第五届研创展\hekai\VP4L\MultiCamera\LogFiles\test.txt','%n%n%n%n%n%n%n%n');
     M=[data1,data2,data3,data4,data5,data6,data7,data8];
    catch
     
    end
end
delete(timerfind);
% set(handles.pushbutton2,'Visible','on');
% set(handles.pushbutton3,'Visible','on');
% set(handles.pushbutton4,'Visible','on');
% set(handles.pushbutton5,'Visible','on');
%%
%设置一个0.5s的定时器
t=timer('StartDelay',1,'TimerFcn',{@t_TimerFcn,handles},'Period',0.5,'ExecutionMode','fixedRate');
start(t);%开启定时器
% stop(timerfind);
% delete(timerfind);
%%
%暂停的回调函数
function PauseBtn_Callback(~, ~, ~)
% hObject    handle to PauseBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stop(timerfind);
delete(timerfind);
%%
%退出的回调函数
function ExitBtn_Callback(~, ~, handles)
% hObject    handle to ExitBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
   stop(timerfind);
   delete(timerfind);
catch
    
end
close(handles.figure1);
%%
%定时器的回调函数
function t_TimerFcn(~, ~,handles)
    global M
    global num
    global a
    global result_all
    try
    [data1,data2,data3,data4,data5,data6,data7,data8]=textread('C:\Users\VLC\Desktop\zzt\第五届研创展\hekai\VP4L\MultiCamera\LogFiles\test.txt','%n%n%n%n%n%n%n%n','headerlines', size(M,1));
    M1=[data1,data2,data3,data4,data5,data6,data7,data8];
    if(~isempty(M1))
        M(size(M,1)+1:size(M,1)+size(M1,1),:)=M1(1:size(M1,1),:);
    else
        num=num+1;  
        if(num>50)%如果位置始终不更新，停止定时器
            stop(timerfind);
            delete(timerfind);
        end
    end
    result_all=VP4L_the_same_high1(M(size(M,1),1),M(size(M,1),2),M(size(M,1),3),M(size(M,1),4),M(size(M,1),5),M(size(M,1),6),M(size(M,1),7),M(size(M,1),8));  
    set(handles.x_axis,'string',num2str(result_all(2)));%坐标显示
    set(handles.y_axis,'string',num2str(result_all(1)));
%     if(result_all(1)<=12.5)
%         set(handles.pushbutton2,'Visible','on');
%         set(handles.pushbutton3,'Visible','off');
%         set(handles.pushbutton4,'Visible','off');
%         set(handles.pushbutton5,'Visible','off');
%     elseif(result_all(1)>12.5&&result_all(1)<=25)
%         set(handles.pushbutton2,'Visible','off');
%         set(handles.pushbutton3,'Visible','on');
%         set(handles.pushbutton4,'Visible','off');
%         set(handles.pushbutton5,'Visible','off');
%     elseif(result_all(1)>25&&result_all(1)<=37.5)
%         set(handles.pushbutton2,'Visible','off');
%         set(handles.pushbutton3,'Visible','off');
%         set(handles.pushbutton4,'Visible','on');
%         set(handles.pushbutton5,'Visible','off');
%     elseif(result_all(1)>37.5&&result_all(1)<=50)
%         set(handles.pushbutton2,'Visible','off');
%         set(handles.pushbutton3,'Visible','off');
%         set(handles.pushbutton4,'Visible','off');
%         set(handles.pushbutton5,'Visible','on');
%     end
%%
%绘图
    if(a(5,:)~=result_all)
        a(1,:)=a(2,:);
        a(2,:)=a(3,:);
        a(3,:)=a(4,:);
        a(4,:)=a(5,:);
        a(5,:)=result_all;
        if(a(4,:)==zeros(1,6))
            plot(handles.axes1,a(5,2),a(5,1),'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFace','r','MarkerEdge',[1,0,0],'LineWidth',2);
            set(handles.axes1,'Xlim',[0 50],'Ylim',[0 30]);
            set(handles.axes1,'FontSize',12);
            set(handles.axes1,'FontSize',12);
%             set(handles.axes1,'XGrid','on');
%             set(handles.axes1,'YGrid','on');
%             set(handles.axes1,'XMinorGrid','on');
%             set(handles.axes1,'XMinorTick','on');
%             set(handles.axes1,'YMinorGrid','on');
%             set(handles.axes1,'YMinorTick','on');
            set(handles.axes1,'Box','off');
        elseif(a(3,:)==zeros(1,6))
            plot(handles.axes1,a(4:5,2),a(4:5,1),'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFace','r','MarkerEdge',[1,0,0],'LineWidth',2);
            set(handles.axes1,'Xlim',[0 50],'Ylim',[0 30]);
            set(handles.axes1, 'FontSize',12);
            set(handles.axes1, 'FontSize',12);
%             set(handles.axes1,'XGrid','on');
%             set(handles.axes1,'YGrid','on');
%             set(handles.axes1,'XMinorGrid','on');
%             set(handles.axes1,'XMinorTick','on');
%             set(handles.axes1,'YMinorGrid','on');
%             set(handles.axes1,'YMinorTick','on');
            set(handles.axes1,'Box','off');
        elseif(a(2,:)==zeros(1,6))
            plot(handles.axes1,a(3:5,2),a(3:5,1),'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFace','r','MarkerEdge',[1,0,0],'LineWidth',2);
            set(handles.axes1,'Xlim',[0 50],'Ylim',[0 30]);
            set(handles.axes1, 'FontSize',12);
            set(handles.axes1, 'FontSize',12);
%             set(handles.axes1,'XGrid','on');
%             set(handles.axes1,'YGrid','on');
%             set(handles.axes1,'XMinorGrid','on');
%             set(handles.axes1,'XMinorTick','on');
%             set(handles.axes1,'YMinorGrid','on');
%             set(handles.axes1,'YMinorTick','on');
            set(handles.axes1,'Box','off');
        elseif(a(1,:)==zeros(1,6))
            plot(handles.axes1,a(2:5,2),a(2:5,1),'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFace','r','MarkerEdge',[1,0,0],'LineWidth',2);
            set(handles.axes1,'Xlim',[0 50],'Ylim',[0 30]);
            set(handles.axes1, 'FontSize',12);
            set(handles.axes1, 'FontSize',12);
%             set(handles.axes1,'XGrid','on');
%             set(handles.axes1,'YGrid','on');
%             set(handles.axes1,'XMinorGrid','on');
%             set(handles.axes1,'XMinorTick','on');
%             set(handles.axes1,'YMinorGrid','on');
%             set(handles.axes1,'YMinorTick','on');
            set(handles.axes1,'Box','off');
        else
            plot(handles.axes1,a(:,2),a(:,1),'LineStyle','none','Marker','o','MarkerSize',5,'MarkerFace','r','MarkerEdge',[1,0,0],'LineWidth',2);
            set(handles.axes1,'Xlim',[0 50],'Ylim',[0 30]);
            set(handles.axes1, 'FontSize',12);
            set(handles.axes1, 'FontSize',12);
%             set(handles.axes1,'XGrid','on');
%             set(handles.axes1,'YGrid','on');
%             set(handles.axes1,'XMinorGrid','on');
%             set(handles.axes1,'XMinorTick','on');
%             set(handles.axes1,'YMinorGrid','on');
%             set(handles.axes1,'YMinorTick','on');
            set(handles.axes1,'Box','off');
        end
    end  
    fprintf('%f  %f  %f  %f  %f  %f  \n',result_all);
    catch
        return
    end
    %%

   
% hObject    handle to StartBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)


% set(handles.axes1,'Xlim',[0 100],'Ylim',[0 200]);
% set(handles.axes1,'handlevisibility','off','visible','off');
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
