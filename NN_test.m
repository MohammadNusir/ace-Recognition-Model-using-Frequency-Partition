function Out = NN_test(I,My_test)

%clear memory
%clear all
%clc
%%%%load('MData.mat')
%%%%I = MData.I;%%% the real image with gray scale
nump=40;  % number of classes
n=10;     % number of images per class
% training images 
%%%% the length of each image 10304
P=[] ; 
for i = 1 : length(I) 
    var = I{i};
    var = var(:)';
    P=[P ; var];
end
P = P'; % with size of 10304 × 400
% testing images 
N = [] ; 
for i = 1 : length(I)
    N = [ N ; My_test(:)'] ; 
end
N = N';
% Normalization
P=P/256;
N=N/256;
P=double(P);
N=double(N);
% display the training images 
%%%figure(1),
%%%for i=1:n*nump
%%%    im=reshape(P(:,i), [112 92]);
%%%    subplot(nump,n,i),imshow(im);title(strcat('Train image/Class #', int2str(ceil(i/n))))
%%%end
% display the testing images 
%%%figure,
%%%[a,b] = size(N); 
%%%for i=1:n*b
%%%    im=reshape(N(:,i), [112 92]);
%%%   % im=imresize(im,20);        % resize the image to make it clear 
%%%    subplot(b,n,i),imshow(im);title(strcat('test image #', int2str(i)))
%%%end
% targets
T = zeros(40,400);
for i = 1 : 40
for j = 1 : 10 
T(i,(((i-1)*10) +j)) = 1 ; 
end
end
%%%%T size 40 × 400
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S1=5;   % numbe of hidden layers 5
S2=40;   % number of output layers (= number of classes)3

[R,Q]=size(P);       % 10304 × 400
epochs = 10000;      % number of iterations
goal_err = 10e-5;    % goal error
a=0.1;                        % define the range of random variables
b=-0.1;

W1=a + (b-a) *rand(S1,R);     % 5 × 10304 Weights between Input and Hidden Neurons
W2=a + (b-a) *rand(S2,S1);    % 40 × 5    Weights between Hidden and Output Neurons
b1=a + (b-a) *rand(S1,1);     % 5 × 1     Weights between Input and Hidden Neurons
b2=a + (b-a) *rand(S2,1);     % 40 × 1    Weights between Hidden and Output Neurons

n1=W1*P;                      %  (5 × 10304) × (10304 × 400) = 5 × 400   
A1=logsig(n1);                %  5 × 400  
n2=W2*A1;                     %  (40 × 5) × (5 × 400) = 40 × 400 
A2=logsig(n2);                %  40 × 400  
e=A2-T;                       %  40 × 400  
error =0.5* mean(mean(e.*e)); %  40 × 400    
nntwarn off
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for  itr =1:epochs            %  10000
    if error <= goal_err 
        break
    else
         for i=1:Q            % 400
            df1=dlogsig(n1,A1(:,i));    %  5 × 400 
            df2=dlogsig(n2,A2(:,i));    %  40 × 400 
            s2 = -2*diag(df2) * e(:,i);%  (40 × 40) × (40 × 1) = 40 × 1    		       
            s1 = diag(df1)* (W2'* s2); %  (5 × 5) × (5 × 40)×(40 × 1)= 5 × 1
            W2 = W2- (0.1 * s2 * A1(:,i)');% (40 × 5) - (40 × 1)×(1 × 5)= 40 × 5
            b2 = b2-0.1*s2;             % (40 × 1)- (40 × 1)= 40 × 1
            W1 = W1- (0.1 * s1 * P(:,i)');% (5 × 10304) - (5 × 1)×(1 × 10304)= 5 × 10304
            b1 = b1-0.1*s1;             %  (5 × 1)-(5 × 1)= 5 × 1

            A1(:,i)=logsig(W1*P(:,i),b1);% (5 × 10304)×(10304 × 1)= 5 × 1
            A2(:,i)=logsig(W2*A1(:,i),b2);% =40 × 1
         end
            e = T - A2;                  % (40 × 400) - (40 × 400)= 40 × 400 
            error =0.5*mean(mean(e.*e)); %= 40 × 400
            % disp(sprintf('Iteration :%5d        mse :%12.6f%',itr,error));
            mse(itr)=error;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  N , W1, W2, T , mse

threshold=0.9;   % threshold of the system (higher threshold = more accuracy)

% training images result

%TrnOutput=real(A2)
TrnOutput=real(A2>threshold)    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% applying test images to NN
n1=W1*N;           % (5 × 10304)×(10304 × 400) = 5 × 400 >>> N = (10304 × 400)
A1=logsig(n1);     %  = 5 × 400
n2=W2*A1;          %  = 40 × 400
Astest=logsig(n2); %  = 40 × 400

Out = find(max(Astest)== Astest);
% testing images result
figure ; imshow(uint8(A2)); 
figure ; imshow(uint8(A1)); 
figure ; imshow(uint8(A2test));
%TstOutput=real(A2test)
TstOutput=real(Astest>threshold)


% recognition rate
wrong=size(find(TstOutput-T),1);
recognition_rate=100*(size(N,2)-wrong)/size(N,2)