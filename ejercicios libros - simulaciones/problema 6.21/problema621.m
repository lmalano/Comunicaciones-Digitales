clc
clear all
close all

T = 1;
tau = T/2;
K = -6:6;
Xm = zeros(13,13); % se genera matriz vacia del sistema de ecuaciones
% q = [0;0;0;0;0;0;1;0;0;0;0;0;0]; % condicion para cero ISI. Xinv*Xm*cn = Xinv*q
No = 1;


%se genera X*Xt

for n = K % se arma la matriz Xm
    for m = K
        Xm(m+7,n+7) = X(m*T - n*tau);
    end
end

Xt = transpose(Xm);

Ry = Xt*Xm + (No/2)*eye(13);

%genero Ray
for k = K
    Ray(k+7,1) = X(k - k/2); % Ray=Xm(7,:) %toda la fila 7 (fila central) FORMA VALIDA COMPROBADA
end

cn = inv(Ry)*Ray; % coeficientes del equalizador
t = -12*T:T/2:12*T; % se generan pasos para sobremuestrear la señal

for n = 1:size(t,2) %  genera 21 valores de x(t) alrededor de cero
    x(n) = X(t(n)) + ((No/2)^(1/2))*rand(1);
end

%me genera la salida del pulso del equalizador

for m = 1:size(t,2)
    suma = 0;
    for n = 1:size(K,2)
        suma = suma + cn(n)*X(t(m)*T - K(n)*tau);
    end
    
    salida(m) = suma;
end


salida = downsample(salida,2);

figure(1)
stem((-size(x,2)+1)/2:(size(x,2)-1)/2,x)
title('señal a la entrada del ecualizador')

figure(2)
stem((-size(salida,2)+1)/2:(size(salida,2)-1)/2,salida)
title('señal a la salida del ecualizador')

equ = conv(cn,1);

figure(3)
stem((-length(equ)+1)/2:(length(equ)-1)/2,equ)
title('respuesta al impulso del ecualizador')
