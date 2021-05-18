function Out = Haar(I,FigV) %Detect objects using Viola-Jones Algorithm
[a,b,c]= size(I);
if c > 1 
%%%%%%%%%%%%%%%%%% To detect Face
FDetect = vision.CascadeObjectDetector;
%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);
Fout(BB,I,'Face Detection',FigV); 
Pf(1)= BB(2);Pf(2)= BB(4)+BB(2);Pf(3)= BB(1);Pf(4)= BB(3)+ BB(1);
%%%%%%%%%%%%%%%%%% To detect Nose
% vision.CascadeObjectDetector('Nose');
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);
BB=step(NoseDetect,I(Pf(1):Pf(2),Pf(3):Pf(4)));
BB(:,1) = BB(:,1) + Pf(3) ; BB(:,2) = BB(:,2) + Pf(1) ;
[a,b,c] = size(BB); BB = BB(a,:); 
Fout(BB,I,'Nose Detection',FigV);
Pn(1)= BB(2);Pn(2)= BB(4)+BB(2);Pn(3)= BB(1);Pn(4)= BB(3)+ BB(1);
%%%%%%%%%%%%%%%%%% To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);
BB=step(MouthDetect,I(Pf(1):Pf(2),Pf(3):Pf(4)));
BB(:,1) = BB(:,1) + Pf(3) ; BB(:,2) = BB(:,2) + Pf(1) ;
[a,b,c] = size(BB); BB = BB(a,:); 
Fout(BB,I,'Mouth Detection',FigV);
Pm(1)= BB(2);Pm(2)= BB(4)+BB(2);Pm(3)= BB(1);Pm(4)= BB(3)+ BB(1);
%%%%%%%%%%%%%%%%%% To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,I(Pf(1):Pf(2),Pf(3):Pf(4)));
BB(:,1) = BB(:,1) + Pf(3) ; BB(:,2) = BB(:,2) + Pf(1) ;
[a,b,c] = size(BB); BB = BB(a,:); 
Fout(BB,I,'Eyes Detection',FigV);
Pe(1)= BB(2);Pe(2)= BB(4)+BB(2);Pe(3)= BB(1);Pe(4)= BB(3)+ BB(1);
% Eyes=imcrop(I,BB);
% figure,imshow(Eyes);
Out.f = Pf;
Out.m = Pm; 
Out.n = Pn;
Out.e = Pe; 
else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% To detect Face
FDetect = vision.CascadeObjectDetector;
%Returns Bounding Box values based on number of objects
BB = step(FDetect,I);
Fout(BB,I,'Face Detection',FigV); 
[a,b] = size(BB); 
if a 
Pf(1)= BB(2);Pf(2)= BB(4)+BB(2);Pf(3)= BB(1);Pf(4)= BB(3)+ BB(1);
else
    Pf = [] ; 
end
%%%%%%%%%%%%%%%%%% To detect Nose
% vision.CascadeObjectDetector('Nose');
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',16);
BB=step(NoseDetect,I);
[a,b,c] = size(BB); 
if a
    BB = BB(a,:); Fout(BB,I,'Nose Detection',FigV);
    Pn(1)= BB(2);Pn(2)= BB(4)+BB(2);Pn(3)= BB(1);Pn(4)= BB(3)+ BB(1);
else
    Fout(BB,I,'Nose Detection',FigV);
    Pn = [] ;
end
%%%%%%%%%%%%%%%%%% To detect Mouth
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',16);
BB=step(MouthDetect,I);
[a,b,c] = size(BB); 
if a
    BB = BB(a,:); Fout(BB,I,'Mouth Detection',FigV);
    Pm(1)= BB(2);Pm(2)= BB(4)+BB(2);Pm(3)= BB(1);Pm(4)= BB(3)+ BB(1);
else
    Fout(BB,I,'Mouth Detection',FigV);
    Pm = [] ;
end
%%%%%%%%%%%%%%%%%% To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BB=step(EyeDetect,I);
[a,b,c] = size(BB);
if a
     BB = BB(a,:);Fout(BB,I,'Eyes Detection',FigV);
     Pe(1)= BB(2);Pe(2)= BB(4)+BB(2);Pe(3)= BB(1);Pe(4)= BB(3)+ BB(1);
else
     Fout(BB,I,'Eyes Detection',FigV);
     Pe = [] ;
end
% Eyes=imcrop(I,BB);
% figure,imshow(Eyes);
Out.f = Pf;
Out.m = Pm; 
Out.n = Pn;
Out.e = Pe;  
end
end
function Fout(BB,I,T,FigV)
if FigV
figure('Name','HAAR-Cascade');imshow(I); hold on
for i = 1:size(BB,1)
 rectangle('Position',BB(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','r')
end
title(T);hold off;
end
end