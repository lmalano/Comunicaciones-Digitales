clear all
close all
clc

T = 1;
M = 2;
tau = T/M;
K = -6:6;
Xm = zeros(13,13); % se genera matriz vacia del sistema de ecuaciones
No = 0.1;
canal = [0.1 0.3 0 0.5 1 0.5 0 0.3 0.1];
tapCentral = 5;

for k = K
    for n = K
        m = tapCentral + M*k - n;
        if m <= 0 || m > length(canal)
            Xm(k+7,n+7) = 0;
        else
            Xm(k+7,n+7) = canal(m);
        end
    end
end

Ry = transpose(Xm)*Xm + (No/2)*eye(13);

Ray = [0;0;0.1;0.3;0;0.5;1;0.5;0;0.3;0.1;0;0];
cOptimo = inv(Ry)*Ray;

salida = conv(cOptimo,canal);

figure(1)
stem(0:length(salida)-1,salida)
title('salida del ecualizador')

figure(2)
stem(0:length(canal)-1,canal)
title('respuesta del canal')