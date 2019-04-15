clear;clc;close all

% Respuestas al impulso del canal pedidos:
% h=[0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0 0.21 0.03 0.07]; %canal1 Proakis
h=[0.47 0.815 0.407]; %canal 2 Proakis
% h = [0.00990099009900990 0.0153846153846154 0.0270270270270270 0.0588235294117647 0.200000000000000 1 0.200000000000000 0.0588235294117647 0.0270270270270270 0.0153846153846154 0.00990099009900990];

%estos canales h no se usan
%h=[0.227 0.460 0.688 0.460 0.227]; %canal3 Proakis
%h=[0.05 -0.063 0.088 -0.126 -0.25 0.9047 0.25 0 0.126 0.038 0.088]; %canal4 Proak2 

% Grafico la respuesta del canal con fvtool
%fvtool(h);
%freqz(h)%reveer la parte de representacion en frecuencia normalizada

m =length(h);
delay = (m-1)/2;
stem((-delay:delay),h)
legend('Respuesta al impulso del canal')

N = delay + 1;    % Num de coeficientes del equalizador directo (Precursor)
M = delay;        % Num de coeficientes del filtro realimentado (Postcursor)

% Nºde simbolos a transmitir
simbolos=1200; 

MSE=zeros(simbolos,1);
beta = 0.5/(((N + M))*(h*h') ); % paso de adaptacion óptimo

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%calculo de la matriz de correlacion
sigma=0.01;                % desviacion estandard de ruido gaussiano
for k=1:N
	if k<=m
		phi(k)=h(k:m)*h(1:m-k+1)' + sigma^2;
	else	phi(k)=0; end
end
PHI=toeplitz(phi);
% calculo de la matriz P ó alfa dependiendo de la notacion

p = (fliplr(h)).';
p = p(1:N);

MMSE        = 1 - p'*inv(PHI)*p;
lambda      = eig(PHI);
eignsprd    = max(lambda)/min(lambda);
taumax      = 1/(4*beta*min(lambda));
taumin      = 1/(4*beta*max(lambda));
MSEaprx     = MMSE;
disp([' Eigenvalue spread = ' num2str(eignsprd)])
disp([' Maximum time constant of the learning curve = ' num2str(taumax)])
disp([' Minimum time constant of the learning curve = ' num2str(taumin)])
disp([' Expected steady-state MSE = ' num2str(MSEaprx)])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


EsNodB = 2:11;               % Determina la relación en decibeles entre la energia del símbolo Es y la densidad espectral de potencia de ruido No
EsNo = 10.^(EsNodB/10);
N0 = 1./EsNo;
for i = 1:length(N0)
    
    realizaciones=1;
    MSE=zeros(simbolos-(N+M),realizaciones);
    for aux =1:realizaciones   % numero de realizaciones independientes

        % Genero un vector con 1000 valores equiprobables de -1 y 1
        s=randsrc(1,simbolos,[-1,1]); 

        % Hallamos los simbolos transmitidos por el canal.
        so=filter(h,1,s);
        n = sigma*randn(1,length(so));
        y = so + n;    % simbolos recibidos a la entrada del ecualizador

        % ECUALIZACION
        v   = zeros((N+M),simbolos); % Matriz de coeficientes (N+M) x simbolos
        scl = zeros(1,simbolos);
        Q   = zeros(1,simbolos);
            for k=1:simbolos-(N+M)
                w=[y(k+N-1:-1:k)' ; s(k:k+M-1)' ];
                % Ahora se multiplica  el coeficiente 1 por el ultimo simbolo
                % ingresado a la estructura.
                Q(k)=v(:,k).'*w;

                scl(k)=sign(Q(k));      % Detector de nivel

                e = s(k) - Q(k);        % Se halla el error

                v(:,k+1) = v(:,k) + beta*e*conj(w); %version del training 

                MSE(k,aux) = MSE(k,aux) + e^2;
            end
    end

    MSE_av = mean(MSE,2);
    % figure
    % semilogy(MSE_av)
    % title('Evolucion del MSE del training')
    % xlabel('Iteraciones')
    % ylabel('MSE')
    % hold on
    % mMSE=MMSE*ones(1,length(MSE_av));
    % plot(mMSE,'-.b','LineWidth',3)
    % plot(2*mMSE,'--k','LineWidth',3)
    % legend(['Paso de adap. = ',num2str(2*beta)],'MMSE','2*MMSE');

    %--------------------calculo de la tasa de errores------------------%

    error = sum(scl(1:(end-N-M))~=s(1:end-N-M));
    tasaError(i) = error/(simbolos-N-M);
%     disp(['tasa de error: ' num2str(tasaError)])
    
end
    figure(9)
    semilogy(EsNodB,0.5*erfc(sqrt(EsNo)),'k');
    hold on; semilogy(EsNodB,tasaError,'b:o')
    title('Curva de tasa de error de Símbolos (SER)')
    xlabel('Es/No (dB)')
    ylabel('Probabilidad de error')
    grid on

%-------------------------------------------------------------------%

% eyediagram(so,5)
% 
% eyediagram(Q,5)

%---------------------grafico a la entrada--------------------------%
% figure(3)
% stem(y)
% title('señal a la entrada del ecualizador')
% %-------------------------------------------------------------------%
% 
% 
% %---------------------grafico de la señal a la salida---------------%
% 
% figure(4)
% stem(Q)
% title('señal a la salida del ecualizador')
% %-------------------------------------------------------------------%
% 
% %---------------diagrama de constelacion a la entrada del ecu--------%
% 
% figure(5)
% stem(y(100:end-(N+M)),zeros(length(y(100:end-(N+M)))))
% title('diagrama de constelacion a la entrada del ecualizador')
% 
% %-------------------------------------------------------------------%
% 
% 
% %---------------diagrama de constelacion a la salida del ecu--------%
% 
% figure(6)
% stem(Q(100:end-(N+M)),zeros(length(Q(100:end-(N+M)))))
% title('diagrama de constelacion a la salida del ecualizador')
% 
% %-------------------------------------------------------------------%
