clc;close all

UpF= 4;                 % Upsampling factor
N = 11;                 % Longitud equalizador ZF. Elijo impar
L = N;                  % Simbolos a corregir

%la respuesta al impulso del canal es:
%h=[0.04 -0.05 0.07 -0.21 -0.5 0.72 0.36 0 0.21 0.03 0.07]; %canal1 Proakis
%h=[0.227 0.460 0.688 0.460 0.227]; %canal3 Proakis
%h=[0.05 -0.063 0.088 -0.126 -0.25 0.9047 0.25 0 0.126 0.038 0.088]; %canal4 Proak2 
h =[-0.2 0.5 1 0.5 -0.2]; % Canal Proakis ref Nº2

h_i =interp(h,UpF,2); 
h_i = h_i(1:[UpF*(length(h)-1)+1]); % Para que tenga simetria positiva FIR 1
h_i = h_i./sqrt(h_i*h_i');


Nfft1 = length(rcTxFilt) + length(h_i) - 1;    
GtC = fft(rcTxFilt,Nfft1).*fft(h_i,Nfft1);
gtc = real(ifft(GtC,Nfft1));

Nfft2 = Nfft1 + length(rcRxFilt)-1;
GtCGr = fft(gtc,Nfft2).*fft(rcRxFilt,Nfft2);
gtcgr = real(ifft(GtCGr,Nfft2));

g_tcg_r =conv(rcRxFilt,conv(rcTxFilt,h_i)); % por el lado temporal

Delay = 2*(length(rcTxFilt) -1)/2 + (length(h)-1)*4/2;
Delay_reverse = length(gtcgr)-Delay - 1;

clear index_matrix; clear Matriz


    
aux = zeros(N,1); aux((N+1)/2) = 1;
M = length(gtcgr);


Symbol_index = -UpF*(L-1)/2:4:UpF*(L-1)/2;
for i=1:L
    index = fliplr( [-(N-1)/2:(N-1)/2] + [(Delay_reverse) + Symbol_index(i)]);
    index_matrix(i,:) = index; 
    Matriz(i,:) = gtcgr(index);
end
ZF_e=(inv(Matriz)*aux).';               % Vector de coeficientes
gtcgr_e = conv(ZF_e,gtcgr);             % Pulso ecualizado


figure
stem(downsample(gtcgr_e((N-1)/2:end),4))
title('Pulso Ecualizado')
xlabel('Samples')
ylabel('Amplitud')

figure
plot(g_tcg_r,'r*');
hold on
stem(gtcgr,'k');
legend('Equivalent Filter by conv','Equivalent Filter by fft')

    
