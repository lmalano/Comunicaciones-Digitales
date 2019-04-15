clc
clear all
close all

T = 1;
M = 2; % factor de sobremuestreo
tau = T/M;
K = -2:2;
Xm = zeros(5,5); % se genera matriz vacia del sistema de ecuaciones
q = [0;0;1;0;0]; % condicion para cero ISI. Xinv*Xm*cn = Xinv*q
canal = [1/60 1/30 1/16 1/14 1/10 1/5 1/2 2/3 3/4 1 1/8 1/16 1/32 1/64 1/128 1/256]; % respuesta del canal
tapCentral = 10; % indica que posicion de muestras representa el tap central del canal

for k = K
    for n = K
        Xm(k+3,n+3) = canal(tapCentral + M*k - n);
    end
end

cOptimo = inv(Xm)*q;

cOptimo=cOptimo/max(cOptimo);

y = conv(canal,cOptimo);


% for m = 1:length(canal)
%     suma = 0;
%     for n = 1:length(cOptimo)
%         suma = suma + cOptimo(n)*canal(m);
%     end
%     y(m) = suma;
% end

figure(1)
stem(0:length(y)-1,y)

figure(2)
stem(0:length(canal)-1,canal)
