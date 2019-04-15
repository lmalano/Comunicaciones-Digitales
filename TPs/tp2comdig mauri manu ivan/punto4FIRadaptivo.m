%FIR adaptivo punto 4 Tp2

clear all;
 close all;
N=1000;			        	% length of the information sequence
K=5;
 actual_isi=[0.05 -0.063 0.088 -0.126 -0.25 0.9047 0.25 0 0.126 0.038 0.088];
%  actual_isi=[1/26 1/17 1/10 1/5 1/2 1 1/2 1/5 1/10 1/17 1/26];
  
sigma=0.01;
delta=0.115;
Num_of_realizations=10000;
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
  y=y+noise;
 
                                                                           
  % Now the equalization part follows.
  estimated_c=[0 0 0 0 0 1 0 0 0 0 0];	% initial estimate of ISI
  for k=1:N-2*K,
    y_k=y(k:k+2*K);
    z_k=estimated_c*y_k.';
    zz_k(k)=z_k;
    e_k=info(k)-z_k;
    estimated_c = estimated_c + delta*e_k*y_k;
    mse(k)=e_k^2;
    
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
stem(y_k)
title('Señal sin ecualizar')
figure(4)
stem(zz_k)
title('Salida antes del detector')
