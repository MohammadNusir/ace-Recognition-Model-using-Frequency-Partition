function I = fusionN(Io,I1,I2,FigV)
imt = double(Io) ;
im1 = double(I1) ;
im2 = double(I2) ;
L = 5; %No. of levels
f = [0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]; %frquency partition factor (bt. 0 to 1)
%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(f)
    imf = fpdctf(im1,im2,f(i));
    imf = imf-min(imf(:));
    I{i} = uint8(imf);
end
%%%%%%%%%%%%%%%%%%%%%%
i = i + 1 ; 
imf = lpdctf(im1,im2,L);
I{i} = uint8(imf);
%%%%%%%%%%%%%%%%%%%%%%
i = i + 1 ; 
imf = mrdctf(im1,im2,L);
I{i} = uint8(imf); 
%%%%%%%%%%%%%%%%%%%%
i = i + 1 ;
[X1, U1] = MSVD(im1);
[X2, U2] = MSVD(im2);
X.LL = 0.5*(X1.LL+X2.LL);
D  = (abs(X1.LH)-abs(X2.LH)) >= 0; 
X.LH = D.*X1.LH + (~D).*X2.LH;
D  = (abs(X1.HL)-abs(X2.HL)) >= 0; 
X.HL = D.*X1.HL + (~D).*X2.HL;
D  = (abs(X1.HH)-abs(X2.HH)) >= 0; 
X.HH = D.*X1.HH + (~D).*X2.HH;
U = 0.5*(U1+U2);
imf = IMSVD(X,U);
I{i} = uint8(imf);
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
I{i} = uint8(imf);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end