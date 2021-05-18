function TestHaar
load('MData.mat')
I = MData.I; 
C = length(I);
for i = 1 : C 
    V = Haar(I{i},0);
    F{i} = V.f;
    M{i} = V.m; 
    N{i} = V.n;
    E{i} = V.e; 
end
cf = 0 ;cm = 0 ; cn = 0 ; ce = 0 ;  
for i = 1 : C
[a,b] = size(F{i});
if a==1
    cf = cf + 1 ; 
end
[a,b] = size(M{i});
if a==1
    cm = cm + 1 ; 
end
[a,b] = size(N{i});
if a==1
    cn = cn + 1 ; 
end
[a,b] = size(E{i});
if a==1
    ce = ce + 1 ; 
end
end
disp(['Total number of image = ',num2str(C)])
disp(['number of Face detect = ', num2str(cf/C),'%  ',num2str(cf),'  ',...
    'number of Mouth detect = ',num2str(cm/C),'%  ',num2str(cm),'  ',...
    'number of Nose detect = ',num2str(cn/C),'%  ',num2str(cn),'  ',...
    'number of Eye detect = ',num2str(ce/C),'%  ',num2str(ce)])
end