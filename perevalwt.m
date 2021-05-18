function [op] = perevalwt(imf)
% performance evaluation without reference image
% Standard Deviation 
SD = std2(imf);

%======================================================================

% spatial frequency criteria SF
[M,N] = size(imf);

RF = 0;
for m=1:M
    for n=2:N
        RF = RF + (imf(m,n)-imf(m,n-1))^2;
    end
end
RF = sqrt(RF/(M*N));

CF = 0;
for n=1:N
    for m=2:M
        CF = CF + (imf(m,n)-imf(m-1,n))^2;
    end
end
CF = sqrt(CF/(M*N));
SF = sqrt(RF^2 + CF^2);

op = [SD,SF];