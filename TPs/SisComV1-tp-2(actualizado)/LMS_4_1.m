%FIR adaptivo punto 4 Tp2

clear all;
 close all;
N= 1000;			        	% length of the information sequence

T = 1;                         %Periodo entre simbolos
M = 2;                         %Factor de sobremuestreo
tau = T/M;              %Periodo de sobremuestreo
t = -10*T:tau:T*10;

%               | EJERCICIO 4.1 |
%------------------------------------------------------------------------------------------------
%  actual_isi=[0.05 -0.063 0.088 -0.126 -0.25 0.9047 0.25 0 0.126 0.038 0.088];
 % actual_isi=[0.0099 0.0153 0.0270 0.0588 0.2000 1 0.2000 0.0588 0.0270 0.0153 0.0099];  %canal 1                                           
 % actual_isi= [0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0 0.21 0.03 0.07]; %canal 2
% actual_isi= [0.407 0.815 0.407]; %canal 3
%-------------------------------------------------------------------------------------------------

%               | EJERCICIO 4 CANAL 6.11 |
  actual_isi = 1./(1+((2.*t./T).^2)); % o su equivalente abajo
% actual_isi =  [0.2 0.5 1 0.5 0.2]


K=(length(actual_isi)-1)/2;
sigma=0.01;
% delta=0.115;
Num_of_realizations=1000;
mse_av=zeros(1,N-2*K);

for j=1:Num_of_realizations,   		% Compute the average over a number of realizations.
  % the information sequence
  for i=1:N,
    if (rand<0.5),
      info(i)=-1;
    else
      info(i)=1;
    end;
    
  end;
  
  
  % the channel output
  y=filter(actual_isi,1,info);
  for i=1:2:N, [noise(i) noise(i+1)]=gngauss(sigma); end;
  x = y;
  y=y+noise;
 
  cuentas = 0;                                                                         
  % Now the equalization part follows.
%   estimated_c=[0 0 0 0 0 1 0 0 0 0 0];	% initial estimate of ISI

  estimated_c= zeros(1,2*K+1);
  estimated_c(K+1) = 1;
  Pr = var(y);
  delta = 1/(5*(2*(K+1)*Pr));

  for k=1:N-2*K,
    y_k=y(k:k+2*K);
    z_k=estimated_c*y_k.';
    zz_k(k)=z_k;
    e_k=info(k)-z_k;
    estimated_c = estimated_c + delta*e_k*y_k;
    mse(k)=e_k^2;
    cuentas = cuentas +1;
    
  end;
  coeficientes = fliplr(estimated_c); % Para la implementacion directa
   
  mse_av=mse_av+mse;
  
end;

mse_av=mse_av/Num_of_realizations;	% mean-squared error versus iterations 
% Plotting commands follow.
figure(1)
stem(actual_isi)
title('Canal discreto equivalente')
figure(2)
plot(mse_av)
title('Error cuadratico medio')
figure(3)
stem(y)
title('Señal sin ecualizar')
figure(4)
stem(zz_k)
title('Salida antes del detector')

%deteccion de errores
detectorECU = 2*(zz_k > 0) - 1;
disp('BER con ecualizador')
erroresECU = sum(detectorECU~=info(1:length(zz_k)));
BERECU = erroresECU/length(zz_k)

detectorNoECU = 2*(y > 0) - 1;
disp('BER sin ecualizador')
erroresNoECU = sum(detectorNoECU~=info(1:length(y)));
BERNoECU = erroresNoECU/length(y)

%--------------------------------------------------------------%

%diagramas de constelaciones

figure(5)
stem(y(100:end),zeros(length(y(100:end))))
title('diagrama de constelacion antes del ecualizador')

figure(6)
stem(zz_k(100:end),zeros(length(zz_k(100:end))))
title('diagrama de constelacion despues del ecualizador')

%--------------------------------------------------------------%

%respuesta impulsiva del ecualizador

figure(7)
stem(estimated_c)
title('respuesta al impulso adaptada')