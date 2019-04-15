function [ssf FXs] = plotspect(Ts,x)

%Espectro de potencia

N = length(x);                               % longitud de la señal x
FX = fft(x)/N;                               % Se realiza la FFT                
FXs = abs(fftshift(FX));                          % Se desplaza la FFT a frecuencias negativas
ssf = (ceil(-N/2):ceil(N/2)-1)/(Ts*N);       % Se define el vector frecuencia

end