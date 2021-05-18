function CreatMynet

load('MData.mat');
I    = MData.I ;
nump = 40;
n    = 10; 
P    = [] ; 
for i   = 1 : length(I) 
    var = I{i};
    var = var(:)';
    P   = [P ; var];
end
P    = P';
P   = P/256;
P=double(P);
T = zeros(40,400);
for i = 1 : 40
    for j = 1 : 10 
        T(i,(((i-1)*10) +j)) = 1 ; 
    end
end
S1       = 5 ;
S2       = 40;
[R,Q]    = size(P);
epochs   = 10000;%%%%%%%%%
goal_err = 10e-5;
a        = 0.1;
b        = -0.1;
W1       = a + (b-a) * rand(S1,R);
W2       = a + (b-a) * rand(S2,S1);
b1       = a + (b-a) * rand(S1,1);
b2       = a + (b-a) * rand(S2,1);
n1       = W1 * P;
A1       = logsig(n1/max(max(n1)));
n2       = W2 * A1;
A2       = logsig(n2/max(max(n2)));
e        = A2 - T;
error    = 0.5 * mean( mean( e .* e ) );
nntwarn off
for  itr =1:epochs
    if error <= goal_err 
        break
    else
         for i = 1 : Q
            df1= dlogsig(n1,A1(:,i));
            df2= dlogsig(n2,A2(:,i));
            s2 = -2 * diag(df2) * e(:,i);
            s1 = diag(df1) * (W2' * s2);
            W2 = W2 - (0.1 * s2 * A1(:,i)');
            b2 = b2 - 0.1 * s2;
            W1 = W1 - (0.1 * s1 * P(:,i)');
            b1 = b1 - 0.1 * s1;
            A1(:,i) = logsig(W1 * P(:,i) , b1);
            A2(:,i) = logsig(W2 * A1(:,i) , b2);
         end
            e  = T - A2;
            error   = 0.5 * mean( mean( e .* e ) );
            mse(itr)= error;
    end
end
save('mynet.mat','A2','W1','W2','T','mse');
