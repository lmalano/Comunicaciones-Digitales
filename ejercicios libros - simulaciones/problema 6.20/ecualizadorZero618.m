clc
clear all
close all

T = 1;
tau = T/2;
K = -6:6;
Xm = zeros(size(K,2),size(K,2)); % se genera matriz vacia del sistema de ecuaciones
q = [0;0;0;0;0;0;1;0;0;0;0;0;0]; % condicion para cero ISI. Xinv*Xm*cn = Xinv*q

for n = K % se arma la matriz Xm
    for m = K
        Xm(m+7,n+7) = X(m*T - n*tau);
    end
end

Xinv = inv(Xm); % inversa de Xm. se utiliza para poder obtener los coeficientes cn utilizados para genrar el filtro equalizador
cn = Xinv*q; % se obtienen los coeficientes del equalizador
t = -24*T:tau:25*T; % se generan pasos para sobremuestrear la señal

for n = 1:size(t,2) %  genera 50 valores de x(t) alrededor de cero
    x(n) = X(t(n));
end

%señal equalizada q(t)
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