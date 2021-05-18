function Out = PCA(I,FigV)
[a,b,c] = size(I) ;  
if c > 1 
    Data_gray = rgb2gray(I); 
else
    Data_gray = I; 
end
Data_grayD = im2double(Data_gray);     
if FigV
    figure,
    set(gcf,'numbertitle','off','name','Grayscale Image'),
    imshow(Data_grayD)          
end
Data_mean = mean(Data_grayD);      
[a b] = size(Data_gray); 
Data_meanNew = repmat(Data_mean,a,1); 
DataAdjust = Data_grayD - Data_meanNew; 
cov_data = cov(DataAdjust);   
[V, D] = eig(cov_data); 
V_trans = transpose(V); 
DataAdjust_trans = transpose(DataAdjust);  
FinalData = V_trans * DataAdjust_trans;   
% Start of Inverse PCA code, 
OriginalData_trans = inv(V_trans) * FinalData;                         
OriginalData = transpose(OriginalData_trans) + Data_meanNew;           
if FigV
    figure,
    set(gcf,'numbertitle','off','name','RecoveredImage'),
    imshow(OriginalData)
end
% End of Inverse PCA code 
Out = OriginalData;

end