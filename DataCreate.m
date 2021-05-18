function MData = DataCreate(Path_S)
% Path_S = uigetdir('C:\',' ' );
path(path,Path_S);
listing = dir(Path_S);
A = {listing.name};
B = {listing.isdir};
C = length(B);
K = 1 ;
for i = 1 : C
   if B{i} && ~strcmp(A{i},'.') && ~strcmp(A{i},'..')&& ~strcmp(A{i},'...')
       Np = [Path_S,'\',A{i}];
       Nl = dir(Np);
       Na = {Nl.name};
       Nb = {Nl.isdir};
       for j = 1 : length(Nb)
           if ~Nb{j}
              MData.Name{K} = [Np,'\',Na{j}];
              MData.I{K}    = imread(MData.Name{K});
              K = K + 1;
           end
       end
   end
end

end