function Out = Process(MData,I,FigV)
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Na{1}  = 'frquency partition factor at 0.0';
Na{2}  = 'frquency partition factor at 0.1';
Na{3}  = 'frquency partition factor at 0.2';
Na{4}  = 'frquency partition factor at 0.3';
Na{5}  = 'frquency partition factor at 0.4';
Na{6}  = 'frquency partition factor at 0.5';
Na{7}  = 'frquency partition factor at 0.6';
Na{8}  = 'frquency partition factor at 0.7';
Na{9}  = 'frquency partition factor at 0.8';
Na{10} = 'frquency partition factor at 0.9';
Na{11} = 'frquency partition factor at 1.0';
Na{12} = 'Laplacian phyramid              ';
Na{13} = 'Multi resolution 1D DCT         ';
Na{14} = 'Multi-resolution Singular Value ';
Na{15} = 'Covariance response             ';
%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
%&&&&&&&&&&&&& HAAR 
V = Haar(I,FigV);
Face  = V.f;
Mouth = V.m; 
Nose  = V.n;
Eye   = V.e; 
%&&&&&&&&&&&&& Histogram
[a,b,c] = size(Face); 
if a
    HIFace  = Histogram(I(Face(1):Face(2),Face(3):Face(4)),FigV);
else
    HIFace  = 0;
end
%%%%%
[a,b,c] = size(Mouth); 
if a
    HIMouth = Histogram(I(Mouth(1):Mouth(2),Mouth(3):Mouth(4)),FigV);
else
    HIMouth = 0;
end
%%%%%
[a,b,c] = size(Nose); 
if a
    HINose  = Histogram(I(Nose(1):Nose(2),Nose(3):Nose(4)),FigV);
else
    HINose  = 0;
end
%%%%%
[a,b,c] = size(Eye); 
if a
    HIEye   = Histogram(I(Eye(1):Eye(2),Eye(3):Eye(4)),FigV);
else
    HIEye   = 0;
end
%%%%%
HIIm = I ; 
if length(HIFace) >1
    % HIIm(Face(1):Face(2),Face(3):Face(4))    = HIFace;
end
if length(HINose) >1
    HIIm(Nose(1):Nose(2),Nose(3):Nose(4))    = HINose;
end
if length(HIMouth)>1
    HIIm(Mouth(1):Mouth(2),Mouth(3):Mouth(4))= HIMouth;
end
if length(HIEye)  >1
    HIIm(Eye(1):Eye(2),Eye(3):Eye(4))        = HIEye;
end
if FigV
    figure('Name','Histogram Parts') ; imshow(HIIm);
end
%&&&&&&&&&&&&& LBP
R     = 4 ; % radiace 
LBPIm = LBP(HIIm,R,FigV);
temp = ones(size(HIIm))*255;
temp(R:size(LBPIm,1)+R-1,R:size(LBPIm,2)+R-1) = LBPIm ;
LBPIm = temp ; 
%&&&&&&&&&&&&& PCA
PCAIm = PCA(I,FigV);
%&&&&&&&&&&&&& fusion
FusionIm = fusion(I,LBPIm,PCAIm,FigV);
FusionIm = uint8(FusionIm);
%&&&&&&&&&&&&&&& Total fusion
FusionIms = fusionN(I,LBPIm,PCAIm,FigV);
for i = 1 : length(FusionIms)
    disp(['Fusion ',Na{i},' ' , 'test Only']);
    Out4{i}=NNT(MData,FusionIms{i},0);
end
%&&&&&&&&&&&&& NN
disp('LBP test only');
Out1 = NNT(MData,LBPIm,FigV);
disp('PCA test only');
Out2 = NNT(MData,PCAIm,FigV);
disp('Fusion test only');
Out3 = NNT(MData,FusionIm,FigV);
Out = Out4 ; 

end