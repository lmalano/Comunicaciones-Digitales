


%--------------------------------------------------------------------------  
%   Simulador de un Sistema de Comunicación con Modulación 2PAM en un canal|
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
% |       |   |símbolos |   |         |   |           |  |  | Gaussiano |
% |-------|   |---------|   |---------|   |-----------|  |  |-----------|
%-------------------------------------------------------------------------
%Receptor                       |------------------------> Análisis SER Vs EsNo
%    |-----------|   |--------| | |-----------| 
%    |  Filtro   |   |  Sub-  | | |Conver.    |
% -->| Apareado  |-->|muestreo|-->|de símbolos|----------> Análisis BER Vs EbNo
%    |           |   |        |   |a bits     |
%    |-----------|   |--------|   |-----------|
%--------------------------------------------------------------------------

clear all;close all;clc;
%Parámetros
DataLength = 10000;         % Cantidad de símbolos a transmitir
FreqSymbol = 1.2e3;          % Frecuencia de transmisión de símbolos
NumZeros = 1;                % Cantidad de ceros entre símbolos para asegurar cero ISI(interferencia entre símbolos)
                              %Modificar su valor entre 6 y 12 y justificar degradación respecto a la curva teórica.
                              %Evaluar NumZeros en 19 y justificar la mejora en la curva de SER obtenida 
T = 1;                         %Periodo entre simbolos
M = 2;                         %Factor de sobremuestreo
tau = T/M;              %Periodo de sobremuestreo
t = -10*T:tau:T*10;
                              
SwitchChannel = 'ON';        % ON: Enciende el canal de ruido gaussiano, 
                             % OFF: Apaga el canal de ruido gaussiano
EsNodB = 2:9;               % Determina la relación en decibeles entre la energia del símbolo Es y la densidad espectral de potencia de ruido No
EsNo = 10.^(EsNodB/10);
SwitchSignal = 'RandomData';  % 'RandomData': Datos binarios generados con una distribición uniforme  
                              % 'ProbeData': Datos binarios de ceros y unos intercalados
                              % 'RealData': Datos binarios generados a partir de una imagen
RxFilter = 'Ecualizador';         %'Matched':filtro receptor que se encuentra apareado con el filtro transmisor  
                              %'Ecualizador':filtro receptor que elimina
                              %ISI
ImageFile = 'Image.jpg';      %Cargar imagen a transmitir 
%--------------------------------------------------------------------------
% Diseño del filtro conformador de la señal
RollOff = 0.5;
Span = 10;
Sps = 10;
Tabs= 5;
Shape = 'sqrt'; 

SRRCFilter = rcosdesign(RollOff,Span,Sps,Shape);  % Diseña un filtro del tipo raiz coseno realzado
RCFilter = rcosdesign(RollOff,Span,Sps,'normal'); % Diseña un filtro del tipo coseno realzado
canal = 1./(1+((2.*t./T).^2));                    % Canal del problema ilustrativo 6.11

    

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
    SymbolsAux = 2*(rand(1,DataLength)>0.5)-1;  % Generación de símbolos +/-1
elseif strcmp(SwitchSignal,'RealData')
    SymbolsAux = 2*(Image>0.5)-1;
else
    display('Opcion no valida')   
end
if length(EsNodB)==1
figure(2)
stem(SymbolsAux,'r'), grid;
end
Symbols = upsample(SymbolsAux,NumZeros+1);  % Agregado de ceros entre los símbolos
TxPAMSignal = conv(Symbols,canal);       % Conformación de la señal a transmitir
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
    display('Opción no valida') 
end

NoisySignal = TxPAMSignal+Noise;

%--------------------------------------------------------------------------
%Receptor Digital:
if strcmp(RxFilter,'Matched')
RxPAMSignal = conv(NoisySignal,SRRCFilter);
    if k == 8
%         ojo2(RxPAMSignal,DataLength,RetardoIni,NumZeros)
    end
elseif strcmp(RxFilter,'Ecualizador')            % Aca se usa el canal exponencial del ejemplo 6.11, donde la señal ya paso por tal y aca n ose hace nada
%     RxPAMSignal = conv(TxPAMSignal,ecualizador);
%     RxPAMSignal = downsample(RxPAMSignal,4);
%     RetardoIni = find(abs(RxPAMSignal) == max(abs(RxPAMSignal(1:length(canal)))),1);
%-----------------------------------------------------------------------------
% Ecualizador MMSE
N0 = 1/EsNo(k);
ecualizador = EcMMSE(canal,Tabs,N0);

Gx=(conv(canal, [1 0]));
Hx=(conv(Gx, ecualizador));
Retardo = round(length(Hx)/2);

if (mod(Retardo,2)==0)
    Inicio = 2;
else
    Inicio = 1;
end
%-----------------------------------------------------------------------------
RxPAMSignal = conv(NoisySignal,ecualizador); %señal ecualizada sobremuestreada
    Recu = RxPAMSignal(Inicio:end);
    Recu = downsample(Recu,2); %señal ecualizada submuestreada
    Detector = Recu(((Retardo-Inicio+1)/2):end);
    Constelacion = Recu(((Retardo-Inicio+1)/2):DataLength+((Retardo-Inicio+1)/2)-1);
    
    Detector = 2*(Detector(1:end)>0)-1;
%     if k == 8
%         figure(1)
%         ojo(RxPAMSignal,DataLength,RetardoIni,NumZeros)
%     end
%graficos de señales ecualizada y sin ecualizar
 if(k == 8)
       
     figure(10)
   stem(Constelacion, zeros(1,DataLength));
   title('diagrama de constelacones de señal ecualizada')
       
    r = Retardo - (Tabs-1)/2;
    
    figure(4)
    y = NoisySignal(r:end);
    y = downsample(y,2);
    y = y(1:DataLength);
    stem(y,zeros(1,length(y)))
    title('diagrama de constelacion antes del ecu')
    
    figure(5)
    stem(NoisySignal)
    title('señal sin ecualizar')

    figure(6)
    stem(Recu)
    title('señal ecualizada')
   end
end        
if length(EsNodB)==1
figure(7)
stem(RxPAMSignal);grid;
end
% RetardoIni = 101;      %Retardo para tener en cuenta los transitorios producidos por las conv al inicio y al final de la transmisión
ErrorRetardoIni = 0;   % Modificar su valor entre -9 y 9 y justificar degradación respecto a la curva teórica
ErrorFrecSimbol = 0;   % Modificar su valor entre 0 y -3 y justificar degradación respecto a la curva teórica
% Detector = 2*(RxPAMSignal(RetardoIni+ErrorRetardoIni:NumZeros+1+ErrorFrecSimbol:end)>0)-1; % convierte las muestras de los símbolos recibidas en valores +-1
Detector = Detector(1:length(SymbolsAux));
if length(EsNodB)==1
figure(8)
stem(Detector);grid;
end
NumError(k) = sum(SymbolsAux~=Detector); %Contador de errores
Rxbits = Detector>0;  %Conversor de símbolos a bits
if strcmp(SwitchSignal,'RealData')
% fHat = Bits2Image(ImageFile,Rxbits,num2str(EsNodB(k)));
end
end
pause(2)
%--------------------------------------------------------------------------
%Estimación del tiempo utilizado para la transmisión de la información
M = 2;     %Tipo de modulacion 2PAM, 4PAM, ect
TotalTime = length(Rxbits)/(FreqSymbol*log2(M)*60);
%--------------------------------------------------------------------------
%Análisis del desempeño del sistema de comunicaciones mediante curvas de Bit Error Rate (BER):
simSER = NumError/length(SymbolsAux);  %Estimación del BER obtenido
figure(9)
semilogy(EsNodB,0.5*erfc(sqrt(EsNo)),'k');
hold on; semilogy(EsNodB,simSER,'b:o')
title('Curva de tasa de error de Símbolos (SER)')
xlabel('Es/No (dB)')
ylabel('Probabilidad de error')
grid on

