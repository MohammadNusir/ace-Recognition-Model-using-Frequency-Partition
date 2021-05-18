function[op] = pereval(imt,imf)
% module to performance evaluation

% Root mean square error (RMSE)
[m,n] = size(imt);
RMSE = sqrt(sum((imt(:)-imf(:)).^2)/(m*n));

%percentage fit error (PFE)
PFE = 100*norm(imt(:)-imf(:))/norm(imt(:));

% Peak signal to noise Ratio (PSNR)
L = 256;
PSNR = 10*log10(L^2/RMSE);
op = [PFE,PSNR];