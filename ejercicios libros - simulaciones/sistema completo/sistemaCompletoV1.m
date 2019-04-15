clc
clear all
close all

numSimbolos = 1000000;
rolloff = 0.5;
span = 10;
sps = 2;
No = 0.63095;
T = 1;
t = -5*T:T/2:5*T;
separacion = 9; % cantidad de ceros entre simbolos para evitar ISI
retardo = 30; %retardo hasta detectar el primer simbolo valido
simbgen = 1 - 2*randint(1,numSimbolos); %genero simbolos a transmitir
simb = upsample(simbgen,separacion+1); %agrego ceros para evitar isi

% figure(4)
% stem(simbgen)
% title('simbolos a transmitir')

%creamos la respuesta del canal
canal = 1./(1+((2/T)*t).^2);

%creamos el filtro transmisor-receptor, raiz coseno realzado (estan
%apareados)
g = rcosdesign(rolloff,span,sps,'sqrt');


%modulacion PAM - se modula el simbolo con el filtro transmisor

s = conv(g,simb);

% figure(1)
% stem(0:length(s)-1,s) %señal transmitida
% title('señal transmitida')

%señal distorsionada por el canal

x = conv(s,canal);
x = x + sqrt(No/2)*randn(1,length(x));

% figure(2)
% stem(0:length(x)-1,x)
% title('señal a la entrada del receptor')

%señal a la salida del filtro receptor

q = conv(x,g);

% figure(5)
% stem(q)


% figure(3)
% stem(0:length(q)-1,q)
% title('señal a la salida del filtro receptor')

detector = 2*(q(retardo:separacion+1:end)>0) - 1;
detector = detector(1:numSimbolos);
errores = sum(simbgen~=detector);
SimbErrorRate = errores/numSimbolos