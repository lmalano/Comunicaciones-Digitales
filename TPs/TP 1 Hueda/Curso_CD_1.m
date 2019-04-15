%=======================================================================
% Comunicaciones Digitales
% Prof.: Dr. Mario Hueda (mario.hueda@unc.edu.ar)
% Practico Lab. 1
%=======================================================================
clear;
close all;

%============================================
% Generacion de la Respuesta al Impulso
%============================================
fB = 32e9;	% Velocidad de simbolos (baud rate)
T = 1/fB; % Tiempo entre simbolos
M = 8;  %Factor de sobremuestreo
fs = fB*M;	% Sample rate

beta = .01001; %Factor de roll-off
L = 20;  % 2*L*M+1 es el largo del filtro sobremuestreado
t = [-L:1/M:L]*T; %nuestro rango del dominio
n_delay_filter = L*M; %Retardo del filtro
gn = sinc(t/T).*cos(pi*beta*t/T)./(1-4*beta^2*t.^2/T^2); % Generacion usando muestreo del pulso en el tiempo
%gn=rcosine(fB,fs,'normal',beta,22);  % Generacion usando funcion de matlab 
                                     %gn=rcosine(fB,fs,'sqrt',beta,22);  %  Generacion usando funcion de matlab (raiz cuadrada)
%hace la tf de un rectangulo(pulso)
figure(1)
h = stem(gn);%grafica en tiempo discreto
title('Respuesta al Impulso');
xlabel('n');
grid
%break

%============================================
% Calculo de la Respuesta en Frecuencia
%============================================
Omega = [0:1/2^8:1]*pi;%define el dominio de omega usada para la exp
N = 1000;
n = [0:N];
index = 1;
for omega=Omega
    xn = exp(j*omega*n);%exponencial
    yn = conv(xn,gn);%convulucion de la tf del pulso con la exponencial
    H_Mag(index) = abs(yn(N/2));% guardo la convolucion en valor abs
    H_Fase(index) = angle(yn(N/2)*conj(xn(N/2-n_delay_filter)));%angulo de fase 
    index = index+1;
end

figure(2)
subplot 211
h=plot(Omega/pi,H_Mag);%plotea lo de arriba magnitud de H
title('Magnitud');
ylabel('|H|')
xlabel('\Omega/\pi');
grid
subplot 212
h=plot(Omega/pi,H_Fase);%plotea lo de arriba fase de H
title('Fase');
ylabel('angle(H)')
xlabel('\Omega/\pi');
grid
%break

%============================================
% Generacion Simbolos
%============================================
n_symbols = 10000;
ak = 2*randint(1,n_symbols)-1;%genero nros aleatorios de 1 y -1 10000 veces   ak = 2*randint(1,n_symbols,4)-1 si uso PAM4
xn = zeros(1,n_symbols*M);%hago muchos ceros de  1 a n_symbols*M
xn(1:M:end) = ak;

figure(3)
h = stem(xn(10:10+M*10));
ylabel('x[n]')
xlabel('n');

%============================================
% Señal Transmitida
%============================================

sn = conv(xn,gn);
figure(4)
h = plot(sn((2*L*M+1):(2*L*M+1)*10),'.-');
ylabel('s[n]')
xlabel('n');
%break

%============================================
% Generacion de Diagrama Ojo
%============================================

figure(5)
d = 5; %Delay para centrar el ojo
for m = 2*L+1:n_symbols-(2*L+1)
    sn_p = sn(m*M+d:m*M+d+M);
    plot([-M/2:1:M/2],sn_p)
    hold on
end
grid
