function HIm = Histogram(A,FigV)
[a,b,c] = size(A) ; 
if c > 1 
    A = rgb2gray(A);
end

%Specify the bin range[0 255]
bin=255;
%Find the histogram of the image.
Val=reshape(A,[],1);
Val=double(Val);
I=hist(Val,0:bin);
%Divide the result by number of pixels
Output=I/numel(A);
%Calculate the Cumlative sum
CSum=cumsum(Output);
%Perform the transformation S=T(R) where S and R in the range [ 0 1]
HIm=CSum(A+1);
%Convert the image into uint8
HIm=uint8(HIm*bin);

if FigV
    figure,imshow(A);
    figure,imshow(HIm);
end

end