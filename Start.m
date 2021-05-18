
function Start

%%%%%%%%%%%%%%%%%%%%%%%%%%% Path of Main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P = mfilename('fullpath');
b = length(P);
Fname = mfilename;
a = length(Fname);
PathS = P(1:(b-a));
path(path,PathS) ;
path(path,'C:\Users\m.nusir\Downloads\facedatabase\pose\att_faces');% data
path(path,'C:\Users\m.nusir\Downloads\MainB');% code 
Main;
%%%%%%%%%%%%%%%%%%%%%%%%%%% End Paht Main %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end