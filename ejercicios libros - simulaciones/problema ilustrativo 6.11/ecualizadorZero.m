clc
clear all
close all

T = 1;
tau = T/2;
K = -2:2;
Xm = zeros(5,5); % se genera matriz vacia del sistema de ecuaciones
q = [0;0;1;0;0]; % condicion para cero ISI. Xinv*Xm*cn = Xinv*q
M = 8;


for n = K % se arma la matriz Xm
    for m = K
        Xm(m+3,n+3) = X(m*T - n*tau);
    end
end

Xinv = inv(Xm); % inversa de Xm. se utiliza para poder obtener los coeficientes cn utilizados para genrar el filtro equalizador
cn = Xinv*q; % se obtienen los coeficientes del equalizador
t = -30*T:tau:30*T; % se generan pasos para sobremuestrear la señal

for n = 1:size(t,2) %  genera 21 valores de x(t) alrededor de cero
    x(n) = X(t(n));
end


%señal equalizada q(t)
% for m = 1:size(t,2)
%     suma = 0;
%     for n = 1:size(K,2)
%         suma = suma + cn(n)*X(t(m)*T - K(n)*tau);
%     end
%     
%     salida(m) = suma;
% end

salida = conv(x,cn)
salida = downsample(salida,2);



figure(1)
stem((-size(x,2)+1)/2:(size(x,2)-1)/2,x)
title('señal a la entrada del ecualizador')

figure(2)
stem((-size(salida,2)+1)/2:(size(salida,2)-1)/2,salida)
title('señal a la salida del ecualizador')