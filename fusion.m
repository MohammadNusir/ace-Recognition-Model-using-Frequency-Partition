function Out = fusion(Io,I1,I2,FigV)
imt = double(Io) ;
im1 = double(I1) ;
im2 = double(I2) ;
L = 5; %No. of levels
f = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]; %frquency partition factor (bt. 0 to 1)
%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(f)
    imf = fpdctf(im1,im2,f(i));
    imf = imf-min(imf(:));
    I{i} = imf; 
    if FigV
        figure('Name','Fusion 1'); imshow(imf,[])
        e=imt-imf;
        figure('Name','Fusion Error'); imshow(e,[])
    end
    A = pereval(imt,abs(imf)); %percentage fit error (PFE),% Peak signal to noise Ratio (PSNR)
    Pm(i,1) = A(1);
    Pm(i,2) = A(2); 
    A = perevalwt(imf); % Standard Deviation , % spatial frequency criteria SF
    Pm(i,3) = A(1);
    Pm(i,4) = A(2);
end
%%%%%%%%%%%%%%%%%%%%%%
i = i + 1 ; 
imf = lpdctf(im1,im2,L);
    I{i} = imf; 
    A = pereval(imt,abs(imf)); %percentage fit error (PFE),% Peak signal to noise Ratio (PSNR)
    Pm(i,1) = A(1);
    Pm(i,2) = A(2); 
    A = perevalwt(imf); % Standard Deviation , % spatial frequency criteria SF
    Pm(i,3) = A(1);
    Pm(i,4) = A(2);
if FigV
    figure('Name','Fusion 2'); imshow(imf,[])
    e=imt-imf;
    figure('Name','Fusion Error'); imshow(e,[])
end
%%%%%%%%%%%%%%%%%%%%%%
i = i + 1 ; 
imf = mrdctf(im1,im2,L);
    I{i} = imf; 
    A = pereval(imt,abs(imf)); %percentage fit error (PFE),% Peak signal to noise Ratio (PSNR)
    Pm(i,1) = A(1);
    Pm(i,2) = A(2);
    A = perevalwt(imf); % Standard Deviation , % spatial frequency criteria SF
    Pm(i,3) = A(1);
    Pm(i,4) = A(2);
if FigV
    figure('Name','Fusion 3'); imshow(imf,[])
    e=imt-imf;
    figure('Name','Fusion Error'); imshow(e,[])
end
%%%%%%%%%%%%%%%%%%%%
% by Dr. VPS Naidu, MSDF Lab
% ref: “Image Fusion Technique using Multi-resolution Singular Value Decomposition”,
%       Defence Science Journal, Vol. 61, No.5, pp.479-484, Sep. 2011.
i = i + 1 ;
%apply MSVD
[X1, U1] = MSVD(im1);
[X2, U2] = MSVD(im2);
%fusion starts
X.LL = 0.5*(X1.LL+X2.LL);
D  = (abs(X1.LH)-abs(X2.LH)) >= 0; 
X.LH = D.*X1.LH + (~D).*X2.LH;
D  = (abs(X1.HL)-abs(X2.HL)) >= 0; 
X.HL = D.*X1.HL + (~D).*X2.HL;
D  = (abs(X1.HH)-abs(X2.HH)) >= 0; 
X.HH = D.*X1.HH + (~D).*X2.HH;
%XX = [X.LL, X.LH; X.HL, X.HH];
U = 0.5*(U1+U2);
%apply IMSVD
imf = IMSVD(X,U);
I{i} = imf;
    A = pereval(imt,abs(imf)); %percentage fit error (PFE),% Peak signal to noise Ratio (PSNR)
    Pm(i,1) = A(1);
    Pm(i,2) = A(2);
    A = perevalwt(imf); % Standard Deviation , % spatial frequency criteria SF
    Pm(i,3) = A(1);
    Pm(i,4) = A(2);

%%%%%%%%%%%%%%%%%%%%
 i = i + 1 ;
C = cov([im1(:) im2(:)]);
[V, D] = eig(C);
if D(1,1) >= D(2,2)
  pca = V(:,1)./sum(V(:,1));
else  
  pca = V(:,2)./sum(V(:,2));
end
imf = pca(1)*im1 + pca(2)*im2;
I{i} = imf;
    A = pereval(imt,abs(imf)); %percentage fit error (PFE),% Peak signal to noise Ratio (PSNR)
    Pm(i,1) = A(1);
    Pm(i,2) = A(2);
    A = perevalwt(imf); % Standard Deviation , % spatial frequency criteria SF
    Pm(i,3) = A(1);
    Pm(i,4) = A(2);
%%%%%%%%%%%%%%%%%%%%
% percentage fit error (PFE),
% Peak signal to noise Ratio (PSNR)
% Standard Deviation (SD) , 
% spatial frequency criteria (SFC)
Tia1   =['percentage fit error (PFE)       ';...
         'Peak signal to noise Ratio (PSNR)';...
         'Standard Deviation (SD)          ';...
         'spatial frequency criteria (SFC) '];
Tia2   = '                                    PFE      PSNR      SD      SFC';
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(Tia1);
disp(Tia2);
Pm = (fix(Pm * 1000 )+ 0.1)/1000 ; 
for i =1 : 15 
    a1 = num2str(Pm(i,1));a1 = a1(1:7);
    a2 = num2str(Pm(i,2));a2 = a2(1:7);
    a3 = num2str(Pm(i,3));a3 = a3(1:7);
    a4 = num2str(Pm(i,4));a4 = a4(1:7);
    disp([Na{i},': ',...
        a1,'  ',...
        a2,'  ',...
        a3,'  ',...
        a4]);
end
%Pm%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



Out = I{find(Pm(:,1)== min(Pm(:,1)))};

end
function test 
% fusion quality evaluation metrics
[RMSE,PFE,MAE,CORR,SNR,PSNR,MI,QI,SSIM] = pereval(imt,im1,im2,imf);
fprintf('\n   Fusion Quality Evaluation Metrics:\n');
fprintf('\nroot mean square error           (RMSE): %3f2',RMSE);
fprintf('\nPersentage fit error              (PFE): %3f2',PFE);
fprintf('\nmean absolute error               (MAE): %3f2',MAE);
fprintf('\nCorrelation                      (CORR): %3f2',CORR);
fprintf('\nsignal to noise ration            (SNR): %3f2',SNR);
fprintf('\npeak signal to noise ration      (PSNR): %3f2',PSNR);
fprintf('\nmutual information                 (MI): %3f2',MI);
fprintf('\nquality index                      (QI): %3f2',QI);
fprintf('\nmeasure of structural similarity (SSIM): %3f2',SSIM);
end