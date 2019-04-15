clc;close all
taps=7;
T=1; %periodo
m=2;% tasa de sobremuestreo
K = (taps-1)/2;     %ya que se quieren generar 2*K + 1 taps desde -K hasta K

Xm = zeros(taps,taps); % genero matriz Xm de dim taps
N0=1;
H=[0.02 0.1 0.35 1 0.25 0.15 0.01]; %genero rta del canal implusiva
HF=flip(H);  %si fuera matriz se usa fliplr
tapCentral = round(length(H)/2); %obtengo la posicion del medio

%genero nro aleatorio, le sumo el ruido y lo convoluciono con el canal y
%sumo el ruido y lo ecualixzasmo, generamos retardo se calclula ,
%domsalmpel y stem
simbolos=10;

sim=randsrc(1,simbolos,[-1,1]); %genero 100 simbolos +/-1

Simb = upsample(sim,2);% upsample cada 1 simbolo va 2 ceros para q no haya isi



for i = 0:(taps-1)
    for j = 0:(taps-1)
        
        parametro = tapCentral + K + j -m*i;
        
        if parametro > 0 && parametro <= length(H)
            Xm(i+1,j+1) = HF(parametro);
        else
            Xm(i+1,j+1) = 0;
        end
    end
end

Tx=conv(Simb,H); %convolucion del los simbolos a tranmitir con el canal

Noise = randn(1,length(Tx))*sqrt(N0/2); %genero ruido con el largo del canal

NS=Tx+Noise;%sumo ruido y rta del canal


xmt= transpose(Xm);

Ry=xmt*Xm + (N0/2)*eye(taps);
Ray=Xm(K+1,:).'; 

% display(Xm)

c=inv(Xm)*Ray% calculo vector C optimos

Rx=conv(NS,c) %convolucion de la señal contaminada con los c del coeficiente

Recu = Rx(2:end); %en 2 empieza 
    Recu = downsample(Recu,2); %señal ecualizada submuestreada
    Detector = Recu(2:end);%detetco simbolos +-1
     Detector = 2*(Detector(1:end)>0)-1;


% 
%  y = conv(HN,c); HN seria noise signal h+n
% figure(1)
%  stem(y);
%  ye=y(1:length(y)) %corto la senal para q empieze de 1
% 
% 
% yd = downsample(ye,2);
% figure(2)
% stem(yd);


