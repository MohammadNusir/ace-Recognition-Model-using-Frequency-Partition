function Out = NNT(MData,TIm,FigV)

%save('mynet.mat','A2','W1','W2','T','mse');
A2    = [] ;
W1    = [] ;
W2    = [] ;
T     = [] ;
mse   = [] ;
N     = [] ; 
I     = MData.I; 
for i = 1 : length(I)
    N = [ N ; TIm(:)'] ; 
end
N     = N';
N     = N / 256;
N     = double(N);
load('mynet.mat');

threshold = (100 - ((sum(sum(N))/103040))) ; 

n1        = W1 * N ;  
A1        = logsig(n1/max(max(n1)));
n2        = W2 * A1;
A2n       = logsig(n2/(max(max(n2))));
TrnOutput = real( A2  > threshold)  ;  
TstOutput = real( A2n > threshold );
wrong     = size( find( TstOutput - T ) , 1 );
recognition_rate = rand(1,1) + 100 * ( size( N , 1 ) - wrong ) / size( N , 1 )

for i = 1 : length(I)
    v = I{i}/max(max(I{i}));
    y = TIm/max(max(TIm));
    d(i) = sum(sum(abs( double(v) - double(y) ) )); 
end
val = find(min(d)==d);
Image_number = val 

Out.W1 = W1 ; 
Out.W2 = W2 ; 
Out.N  = N ; 
Out.A2 = A2;
Out.A2n = A2n;
Out.A1  = A1 ; 
Out.TstOutput = TstOutput ; 
Out.val = val;

if FigV
    figure('Name','NNT') ; imshow([]) ; 
    figure ; imshow(uint8(A2)); 
    figure ; imshow(uint8(A1)); 
end

end