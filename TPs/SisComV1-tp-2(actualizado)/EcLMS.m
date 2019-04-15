function [coeficientes] = EcLMS(y,Num_of_realizations,K,N,sigma,info)

%----------------------------ETAPA DE ENTRENAMIENTO----------------------%

close all;
		        	% length of the information sequenc

  Pr = var(y);
  delta = 1/(5*(2*(K+1)*Pr));                   
                    
                    
mse_av=0;
for j=1:Num_of_realizations,   		% Compute the average over a number of realizations.
  
  
  
                                                                           
  estimated_c= zeros(1,2*K+1);
  estimated_c(K+1) = 1;
  
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
% 
 mse_av=mse_av/Num_of_realizations;	% mean-squared error versus iterations 
% Plotting commands follow.
figure(1)
stem(x)
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





end

