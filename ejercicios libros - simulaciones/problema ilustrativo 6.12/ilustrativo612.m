clc
clear all
close all

T = 1;
tau = T/2;
K = -2:2;
Xm = zeros(5,5); % se genera matriz vacia del sistema de ecuaciones
q = [0;0;1;0;0]; % condicion para cero ISI. Xinv*Xm*cn = Xinv*q
No = 0.01;

%se genera X*Xt

for n = K % se arma la matriz Xm
    for m = K
        Xm(m+3,n+3) = X(m*T - n*tau);
    end
end

Xt = transpose(Xm);

Ry = Xt*Xm + (No/2)*eye(5);

%genero Ray
for k = K
    Ray(k+3,1) = X(k - k/2);
end

cn = inv(Ry)*Ray; % coeficientes del equalizador
t = -10*T:T/2:10*T; % se generan pasos para sobremuestrear la señal

for n = 1:size(t,2) %  genera 21 valores de x(t) alrededor de cero
    x(n) = X(t(n)) + ((No/2)^(1/2))*rand(1);
end

%me genera la salida del pulso del equalizador

% for m = 1:size(t,2)
%     suma = 0;
%     for n = 1:size(K,2)
%         suma = suma + cn(n)*X(t(m)*T - K(n)*tau);
%     end
%     
%     salida(m) = suma;
% end

salida = conv(x,cn);
salida = downsample(salida,2);

figure(1)
stem((-size(x,2)+1)/2:(size(x,2)-1)/2,x)
title('señal a la entrada del ecualizador')

figure(2)
stem((-size(salida,2)+1)/2:(size(salida,2)-1)/2,salida)
title('señal a la salida del ecualizador')