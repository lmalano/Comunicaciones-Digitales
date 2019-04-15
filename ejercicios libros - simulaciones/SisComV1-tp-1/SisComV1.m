%--------------------------------------------------------------------------  
%   Simulador de un Sistema de Comunicaci�n con Modulaci�n 2PAM en un canal|
%                       con ruido gaussiano. Version-1.0                   |   
%              Laboratorio de Comunicaciones Digitales FCEFYN-UNC          |
%                                                                          |
%                                    By Martin (martin.ayarde@unc.edu.ar)  |  
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Transmisor                                              |Canal 
% |-------|   |---------|   |---------|   |-----------|  |  |-----------|
% |Gen. de|   |Conver.  |   | Sobre-  |   |  Filtro   |  |  | Canal con | 
% |de bits|-->|de Bits a|-->|muestreo |-->|Conformador|--|->|  ruido    |--> 
% |       |   |s�mbolos |   |         |   |           |  |  | Gaussiano |
% |-------|   |---------|   |---------|   |-----------|  |  |-----------|
%-------------------------------------------------------------------------
%Receptor                       |------------------------> An�lisis SER Vs EsNo
%    |-----------|   |--------| | |-----------| 
%    |  Filtro   |   |  Sub-  | | |Conver.    |
% -->| Apareado  |-->|muestreo|-->|de s�mbolos|----------> An�lisis BER Vs EbNo
%    |           |   |        |   |a bits     |
%    |-----------|   |--------|   |-----------|
%--------------------------------------------------------------------------
clear all;close all;clc;
%Par�metros
DataLength = 1000000;         % Cantidad de s�mbolos a transmitir
FreqSymbol = 1.2e3;          % Frecuencia de transmisi�n de s�mbolos
RetardoIni = 101;
NumZeros = 9;                % Cantidad de ceros entre s�mbolos para asegurar cero ISI(interferencia entre s�mbolos)
                              %Modificar su valor entre 6 y 12 y justificar degradaci�n respecto a la curva te�rica.
                              %Evaluar NumZeros en 19 y justificar la mejora en la curva de SER obtenida 
SwitchChannel = 'ON';        % ON: Enciende el canal de ruido gaussiano, 
                             % OFF: Apaga el canal de ruido gaussiano
EsNodB = 2:9;               % Determina la relaci�n en decibeles entre la energia del s�mbolo Es y la densidad espectral de potencia de ruido No
EsNo = 10.^(EsNodB/10);
SwitchSignal = 'RandomData';  % 'RandomData': Datos binarios generados con una distribici�n uniforme  
                              % 'ProbeData': Datos binarios de ceros y unos intercalados
                              % 'RealData': Datos binarios generados a partir de una imagen
RxFilter = 'Matched';         %'Matched':filtro receptor que se encuentra apareado con el filtro transmisor  
                              %'NotMatched':filtro receptor que no esta apareado con el filtro transmisor
ImageFile = 'Image.jpg';      %Cargar imagen a transmitir 
%--------------------------------------------------------------------------
% Dise�o del filtro conformador de la se�al
RollOff = 0.5;
Span = 10;
Sps = 10;
Shape = 'sqrt'; 

SRRCFilter = rcosdesign(RollOff,Span,Sps,Shape);  % Dise�a un filtro del tipo raiz coseno realzado
RCFilter = rcosdesign(RollOff,Span,Sps,'normal'); % Dise�a un filtro del tipo coseno realzado
%SRRCFilter = rcosine(1,Sps,Shape,RollOff,floor(Span/2));  para versiones de
%matlab que no soporten rcosdesign reemplazar la linea anterior por esta linea

if length(EsNodB)==1
figure(1)
subplot 211
stem([0:length(SRRCFilter)-1]/(FreqSymbol*Sps),SRRCFilter);grid;
[ssf,FFT] = plotspect(1/(FreqSymbol*Sps),SRRCFilter);
subplot 212
plot(ssf,20*log10(FFT))
grid on;
xlabel('Frequency [Hz]'); ylabel('Magnitude')

end

%--------------------------------------------------------------------------
if strcmp(SwitchSignal,'RealData')
Image = Image2Bits(ImageFile); %Convierte una imagen jpg en un vector de bits
pause(5)
end
NumError = zeros(length(DataLength),1);
for k=1:length(EsNodB)
%--------------------------------------------------------------------------
% Transmisor digital:
%rng(1024)   %Utilizado para generar siempre la misma secuencia de bits aleatorios
if strcmp(SwitchSignal,'ProbeData')
    SymbolsAux = ones(1,DataLength);
    SymbolsAux(2:2:end) = -1;
elseif strcmp(SwitchSignal,'RandomData')
    SymbolsAux = 2*(rand(1,DataLength)>0.5)-1;  % Generaci�n de s�mbolos +/-1
elseif strcmp(SwitchSignal,'RealData')
    SymbolsAux = 2*(Image>0.5)-1;
else
    display('Opcion no valida')   
end
if length(EsNodB)==1
figure(2)
stem(SymbolsAux,'r'), grid;
end
Symbols = upsample(SymbolsAux,NumZeros+1);  % Agregado de ceros entre los s�mbolos
TxPAMSignal = conv(Symbols,SRRCFilter);       % Conformaci�n de la se�al a transmitir
Maximo = max(TxPAMSignal);
if length(EsNodB)==1
figure(3)
subplot 211
plot(TxPAMSignal);grid;
subplot 212
[pxx w] = pwelch(TxPAMSignal,1024,512,1024*2);
plot(w*FreqSymbol*Sps/(2*pi),10*log10(sqrt(pxx)));grid on
xlabel('Frecuencia [Hz]')
ylabel('PSD [dB]');
title(' Densidad Espectral de Potencia de |p[n]|^2')

end
%--------------------------------------------------------------------------
%Canal Gausiano:
if strcmp(SwitchChannel,'ON')
    Noise = randn(1,length(TxPAMSignal))./sqrt(2*EsNo(k));
elseif strcmp(SwitchChannel,'OFF')
    Noise = zeros(1,length(TxPAMSignal));
else
    display('Opci�n no valida') 
end
NoisySignal = TxPAMSignal+Noise;
%--------------------------------------------------------------------------
%Receptor Digital:
if strcmp(RxFilter,'Matched')
RxPAMSignal = conv(NoisySignal,SRRCFilter);
    if k == 8
%         ojo2(RxPAMSignal,DataLength,RetardoIni,NumZeros)
    end
elseif strcmp(RxFilter,'NotMatched')
    RxPAMSignal = conv(NoisySignal,RCFilter);
end        
if length(EsNodB)==1
figure(4)
stem(RxPAMSignal);grid;
end
% RetardoIni = 101;      %Retardo para tener en cuenta los transitorios producidos por las conv al inicio y al final de la transmisi�n
ErrorRetardoIni = 0;   % Modificar su valor entre -9 y 9 y justificar degradaci�n respecto a la curva te�rica
ErrorFrecSimbol = 0;   % Modificar su valor entre 0 y -3 y justificar degradaci�n respecto a la curva te�rica
Detector = 2*(RxPAMSignal(RetardoIni+ErrorRetardoIni:NumZeros+1+ErrorFrecSimbol:end)>0)-1; % convierte las muestras de los s�mbolos recibidas en valores +-1
Detector = Detector(1:length(SymbolsAux));
if length(EsNodB)==1
figure(5)
stem(Detector);grid;
end
NumError(k) = sum(SymbolsAux~=Detector); %Contador de errores
Rxbits = Detector>0;  %Conversor de s�mbolos a bits
if strcmp(SwitchSignal,'RealData')
fHat = Bits2Image(ImageFile,Rxbits,num2str(EsNodB(k)));
end
end
pause(2)
%--------------------------------------------------------------------------
%Estimaci�n del tiempo utilizado para la transmisi�n de la informaci�n
M = 2;     %Tipo de modulacion 2PAM, 4PAM, ect
TotalTime = length(Rxbits)/(FreqSymbol*log2(M)*60);
%--------------------------------------------------------------------------
%An�lisis del desempe�o del sistema de comunicaciones mediante curvas de Bit Error Rate (BER):
simSER = NumError/length(SymbolsAux);  %Estimaci�n del BER obtenido
figure
semilogy(EsNodB,0.5*erfc(sqrt(EsNo)),'k');
hold on; semilogy(EsNodB,simSER,'b:o')
title('Curva de tasa de error de S�mbolos (SER)')
xlabel('Es/No (dB)')
ylabel('Probabilidad de error')
grid on

