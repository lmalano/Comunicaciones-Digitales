function fHat = Bits2Image(ImageFile,Rxbits,strEsNo)
BitResolution=8;
f = imread (ImageFile); %carga la imagen en una matriz tridimensional
Sf = size(f);
w = Sf(1)*Sf(2); 
ww = Sf(1)*Sf(2)*Sf(3);
Ehat= reshape(Rxbits,ww,BitResolution);
Dhat = bi2de(Ehat); 
Dhat = uint8(Dhat);
fHat = reshape(Dhat(1:w),Sf(1),Sf(2));
fHat(:,:,2) = reshape(Dhat(w+1:2*w),Sf(1),Sf(2));
fHat(:,:,3) = reshape(Dhat(2*w+1:end),Sf(1),Sf(2));
figure
imshow (fHat)
title(['Imagen recibida para un EsNo = ' strEsNo ' dB'])
pause(0.5)
end