clc;clear all;close all; 
f = imread ('Image3.jpg'); %carga la imagen en una matriz tridimensional
Sf = size(f);
w = Sf(1)*Sf(2); 
ww = Sf(1)*Sf(2)*Sf(3);
%figure
imshow (f)  
A= reshape(f(:,:,1),1,w);
B = reshape(f(:,:,2),1,w);
C = reshape(f(:,:,3),1,w);
D =[A,B,C];
E=de2bi(D);    %Convierte numeros decimales a numeros binarios
BitResolution=8;
Image=reshape(E,1,ww*BitResolution);
save TxImageFile Image

load ('RxImageFile')
Ehat= reshape(Rxbits,ww,BitResolution);
Dhat = bi2de(Ehat); 
Dhat = uint8(Dhat);
fHat = reshape(Dhat(1:w),Sf(1),Sf(2));
fHat(:,:,2) = reshape(Dhat(w+1:2*w),Sf(1),Sf(2));
fHat(:,:,3) = reshape(Dhat(2*w+1:end),Sf(1),Sf(2));
figure
%subplot 211
%imshow (f)
%subplot 212
imshow (fHat)