function Image = Image2Bits(ImageFile)
f = imread (ImageFile); %carga la imagen en una matriz tridimensional
Sf = size(f);
w = Sf(1)*Sf(2); 
ww = Sf(1)*Sf(2)*Sf(3);
figure
imshow (f)
title('Imagen Transmitida')
A= reshape(f(:,:,1),1,w);
B = reshape(f(:,:,2),1,w);
C = reshape(f(:,:,3),1,w);
D =[A,B,C];
E=de2bi(D);    %Convierte numeros decimales a numeros binarios
BitResolution=8;
Image=reshape(E,1,ww*BitResolution);
%save TxImageFile Image
end
