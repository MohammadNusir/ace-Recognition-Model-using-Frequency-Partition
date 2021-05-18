function varargout = Main(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Main_OpeningFcn, ...
                   'gui_OutputFcn',  @Main_OutputFcn, ...
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
%*************************************************************************%
function Main_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
global C Hand b1 b2 b3 b4 b5 MData
C = 0 ;Hand = handles;
b1 = 0 ; b2 = 0 ; b3 = 0 ; b4 = 0 ; b5 = 0 ; 
%*************************************************************************%
function varargout = Main_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
M = get(handles.figure1,'Position');
scrsz = get(groot,'ScreenSize');
set(handles.figure1,'Position',[(scrsz(3)/16),(scrsz(4)/55),M(3:4)]);
set(handles.figure1,'NumberTitle','off');
set(handles.figure1,'ToolBar','none');
set(handles.figure1,'MenuBar','none');
set(handles.figure1,'Name',MyTxt(1));
set(handles.P1,'Visible','off');
set(handles.P2,'Visible','off');
set(handles.P3,'Visible','off');
set(handles.P4,'Visible','off');
set(handles.P5,'Visible','off');
set(handles.txt,'Visible','off');
set(handles.txtL,'FontSize',15,'String',MyTxt(2));
set(handles.figure1,'WindowButtonMotionFcn',...
    @(hObject, eventdata, handles)MM_Callback);
%*************************************************************************%
function MM_Callback(hObject, eventdata, handles)
global C Hand b2
if C < 1 
  set(Hand.txtL,'FontSize',12,'String',MyTxt(3));
  set(Hand.P1,'String',MyTxt(4));
  set(Hand.P1,'Visible','on');
  set(Hand.P2,'String',MyTxt(5));
  set(Hand.P2,'Visible','on');
  b2 = 1 ;
 C = C+1 ;
end
%*************************************************************************%
function End_Pro
close all
%*************************************************************************%
function P1_Callback(hObject, eventdata, handles)
global Hand b1 b2 b3 MData
SP1 = get(Hand.P1,'String');
if b1 == 0 && strcmp(SP1,MyTxt(4))%Start
  set(Hand.P1,'String',MyTxt(8));
  set(Hand.P2,'String',MyTxt(7));%'Use Old
  set(Hand.P3,'String',MyTxt(5));%End
  b2 = 2 ;%'Use Old
  b3 = 1 ;%End
  set(Hand.P3,'Visible','on'); 
end
if b1 == 1 && strcmp(SP1,MyTxt(8))%Rest
  set(Hand.P1,'String',MyTxt(6));%Create New Data
  a = dir;
  for i = 1 : length(a)
      b = a(i);
      if strcmp(b.name,'MData.mat')
          delete 'MData.mat';
      end
  end
  set(Hand.P2,'String',MyTxt(5));%End
  b2 = 1 ; 
  set(Hand.P3,'Visible','off'); 
end
if b1 == 2 && strcmp(SP1,MyTxt(6))%Create New Data
    set(Hand.figure1,'Visible','off');
    NameDir = uigetdir('C:\',MyTxt(11) );
    MData = DataCreate(NameDir);
    set(Hand.figure1,'Visible','on');
    save('MData.mat','MData');  
    set(Hand.P1,'String',MyTxt(8));
     set(Hand.P2,'String',MyTxt(12));%'Use Old
     set(Hand.P3,'String',MyTxt(5));%End
     b2 = 2 ;
     b3 = 1 ;
     b1 = 1 ; 
     set(Hand.P3,'Visible','on'); 
end
if strcmp(SP1,MyTxt(13))%Run test
    set(Hand.figure1,'Visible','off');
    [filename, pathname] = uigetfile({'*.bmp;*.jpg;*.gif;*.png;*.pgm';'*.*'},...
        MyTxt(13),'Dictionary/');
    if pathname ~= 0
        I = imread([pathname,filename]);
        figure; imshow(I);
        Hand.I = I;
    end
   set(Hand.figure1,'Visible','on');
   set(Hand.P1,'Visible','off');
   set(Hand.P2,'Visible','off');
   RI = Process(MData,I,1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   set(Hand.P1,'Visible','on');
   set(Hand.P1,'String',MyTxt(15));
end
if strcmp(SP1,MyTxt(15))
    End_Pro;
end
b1 = b1 + 1 ;
%*************************************************************************%
function P2_Callback(hObject, eventdata, handles)
global Hand b2 b1 MData
SP2 = get(Hand.P2,'String');
if b2==1 && strcmp(SP2,MyTxt(5))%End
    End_Pro;
end
if b2==2 && (strcmp(SP2,MyTxt(7)) || strcmp(SP2,MyTxt(12)))%use Old
   if exist('MData.mat','file') == 2 
        load('MData.mat','-mat');
        set(Hand.P3,'Visible','off');
        set(Hand.P1,'String',MyTxt(13));
        set(Hand.P2,'String',MyTxt(5));
        b1 = 1;
        b2 = 0;
   else
       set(handles.txt,'String',MyTxt(9));
       set(handles.txt,'Visible','on');
       set(Hand.P3,'Visible','off');
       set(Hand.P2,'String',MyTxt(5));
       pause(5)
       set(handles.txt,'String',MyTxt(10));
       b2 = 0;
   end
end
b2 = b2 + 1 ; 
%*************************************************************************%
function P3_Callback(hObject, eventdata, handles)
global Hand b3
SP3 = get(Hand.P3,'String');
if b3 == 1 && strcmp(get(Hand.P3,'String'),MyTxt(5))%End
    End_Pro;
end
b3 = b3 + 1 ; 
%*************************************************************************%
function P4_Callback(hObject, eventdata, handles)
global Hand b4
SP4 = get(Hand.P4,'String');
%*************************************************************************%
function P5_Callback(hObject, eventdata, handles)
global Hand b5
SP5 = get(Hand.P5,'String');
%*************************************************************************%

%*************************************************************************%

%*************************************************************************%
%*************************************************************************%
%*************************************************************************%