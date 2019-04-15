clc;close all
taps=5;
T=1; %periodo
m=2;% tasa de sobremuestreo
K = (taps-1)/2;     %ya que se quieren generar 2*K + 1 taps desde -K hasta K
recorrido = -K:K;
Xm = zeros(taps,taps); % genero matriz Xm de dim taps

q = zeros(taps,1);% genero vector q
tapCentral = round(length(q)/2); %obtengo la posicion del medio
q(tapCentral) = 1; %condicion para cero ISI



H=[0.1 0.15 1 0.15 0.05]; %genero rta del canal implusiva
HT=flip(H);



for i = 0:(taps-1)
    for j = 0:(taps-1)
        
        parametro = tapCentral + K + j -2*i;
        
        if parametro > 0 && parametro <= length(H)
            Xm(i+1,j+1) = HT(parametro);
        else
            Xm(i+1,j+1) = 0;
        end
    end
end


format compact  
format short 

display(Xm)

c=inv(Xm)*q ;% calculo vector C optimos

% figure(1)
% title('coeficientes del ecualizador')
% stem(c);


y = conv(H,c);
figure(1)
stem(y);
yec=y(1:length(y)); %ver bien xq se empieza de uno ivan m lo dijo y el lo de el sale

yd = downsample(yec,2);

%x*c esto m genera q para verificar
% figure(2)
% 
figure(2)
stem(yd)
