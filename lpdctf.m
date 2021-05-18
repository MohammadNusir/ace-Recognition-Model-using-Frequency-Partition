function[imf] = lpdctf(im1,im2,J)
% Laplacian phyramid based image fusion
% Developed by : VPS Naidu, MSDF Lab
% input: im1 & im2 images to be fused
%        J no. of decomposition levels
% output: imf fused image
imfr = mrdctif(im1,im2,J);
imfc = mrdctif(im1',im2',J)';
imf = 0.5*(imfr+imfc);

function[imf] = mrdctif(im1,im2,J)
%Multi resolution image fusion by DCT
[m,n] = size(im1);
x1 = c2dt1d(im1,m,n);
x2 = c2dt1d(im2,m,n);

for i=1:J
    X1{i} = reduce(x1);
    X2{i} = reduce(x2);
    x1 = X1{i}.L;
    x2 = X2{i}.L;
end

Xf.L = 0.5*(X1{J}.L+X2{J}.L);

for i=J:-1:1
    D = (abs(X1{i}.H) - abs(X2{i}.H)) >=0;
    Xf.H = D.*X1{i}.H + (~D).*X2{i}.H;
    Xf.L = expand(Xf);
end
imf = c1d2d(Xf.L,m,n);

function[R] = c2dt1d(R,m,n)
% conversion from 2D array to 1D vector
% input=>  R:2D image/array, m: no. of rows and n: no. of columns
% output=> R: 1d vector data
R(2:2:end,:)=R(2:2:end,end:-1:1);
R = reshape(R',1,m*n);

function[R] = c1d2d(R,m,n)
% conversion from 1D vector to 2D array
% input=>  R: 1d vector data, m: no. of rows and n: no. of columns
% output=> R:2D image/array
R = reshape(R,n,m)';
R(2:2:end,:)=R(2:2:end,end:-1:1);

function[X] = reduce(x)
%image reduction using dct
n=length(x);
Y = dct(x,n);
X.L = idct(Y(1:n/2));
X.H = x-idct(Y(1:n/2),n);

function[x] = expand(X)
%expand image using dct
n=length(X.H);
x = dct(X.L);
x = idct(x,n)+ X.H;