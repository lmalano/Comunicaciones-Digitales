function [cOptimos] = EcMMSE(x,taps,N0)

% generacion de la matriz Xm
K = (taps-1)/2;     %ya que se quieren generar 2*K + 1 taps desde -K hasta K
recorrido = -K:K;
q = zeros(1,taps);
tapCentral = round(length(q)/2);
q(tapCentral) = 1; %condicion para cero ISI
tapCentral = round(length(x)/2);

for i = 0:(taps-1)
    for j = 0:(taps-1)
        
        parametro = tapCentral + K + j -2*i;
        
        if parametro > 0 && parametro <= length(x)
            Xm(i+1,j+1) = x(parametro);
        else
            Xm(i+1,j+1) = 0;
 end
 end
end


Ry=transpose(Xm)*Xm + (N0/2)*eye(taps);
% Riy=[1/5 1/2 1 1/2 1/5].'; 
Riy=Xm(round(length(q)/2),:)';
cOptimos=inv(Ry)*Riy;		  	% optimal tap coefficients
% find the equalized pulse...

% %  Noise = randn(1,length(z))*sqrt(N0/2);
% %  z=x+Noise;
% equalized_pulse=conv(x,c_opt);    
% % Decimate the pulse to get the samples at the symbol rate.
% decimated_equalized_pulse=equalized_pulse(1:2:length(equalized_pulse));
% % Plotting command follows.
% figure(1)
% stem(z)
% title ('z solari')
% figure(2)
% stem(equalized_pulse)
% title ('equalized_pulse')
% figure(3)
% stem(decimated_equalized_pulse)
% title ('decimated_equalized_pulse')
end
