function[imf] = fpdctf(im1,im2,f)
% Freqency partition 1D DCT based image fusion
% Developed by : VPS Naidu, MSDF Lab

imfr = mrdctif(im1,im2,f);
imfc = mrdctif(im1',im2',f)';
imf = 0.5*(imfr+imfc);

function[imf] = mrdctif(im1,im2,f)
[m,n] = size(im1);
f = round(m*n*f);
mr1 = mrdct(im1,m,n);
mr2 = mrdct(im2,m,n);
D = (abs(mr1)-abs(mr2)) >= 0;
IMFR = D.*mr1 + (~D).*mr2;
IMFR(1:f) = 0.5*(mr1(1:f)+mr2(1:f));
imf = imrdct(IMFR,m,n);

function[IMR] = mrdct(im,m,n)
mn = m*n;
R = im; 
R(2:2:end,:)=R(2:2:end,end:-1:1);
R = reshape(R',1,m*n);
IMR = dct(R,mn);

function[R] = imrdct(R,m,n)
mn = m*n;
imhr = idct(R,mn);
R = reshape(imhr,n,m)';
R(2:2:end,:)=R(2:2:end,end:-1:1);
