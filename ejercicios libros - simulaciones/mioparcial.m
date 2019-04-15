clc;close all
T=1; %periodo
m=2
Vs=T/m; %velocidad de muestra
k=3;
N=1+2*k;
H=[0.02 0.1 0.35 1 0.25 0.15 0.01]; %genero rta del canal implusiva
HT=H.' %trnapongo H
t=[-k*Vs:Vs:k*Vs]; % genero el vector tiempo asociado a H
qa = zeros(1,2*k ); 
q = [qa(1:k),1, qa(k:N-2)]; %genero vector q
qt=q.' %transpongo q
x=zeros(N,N) %genero matriz X
l=k+1; %variable aux para hace la iteracion

for i=1:N
     for j=1:N
         
    x(i,j)=((i-l)*T-((j-l)*T)/2); % al no poder hacer de -k a k, hago de 1 a N, y aplico una correcion en la formula(i-l)
   %calcule la matriz reemplazando el m y el k
    
    for d=1:N
        if x(i,j)==t(d) 
            x(i,j)=H(d);
       
        %reemplazo los valores de la matriz con su valor correspondiente
        %a la respuesta al impulso H
       
        end
     end
     end
end


  for i=1:N
      for j=1:N 
           if (x(i,j)>t(7)  || x(i,j)<t(1) )
            x(i,j)=0;
           end
      end
  end
format rat 
%display(x)


format compact  
format short 
display(x)

c=inv(x)*qt% calculo vector C optimos
c_=c.'
% 
% title('coeficientes del ecualizador')
% stem(c);
% y=filter(c_,1,[H 0 0]);% hago la convolucion de los coeficientes obtenido con la respuesta del canal y se upsamplea la rta del canal
% y=y(3:length(y)); % ...
% for i=1:2:length(y)%aca se downsamplea y se asigna el valor final de los coeficientes salidos del ya ecualizados
%  OutEcuDSampler((i+1)/2)=y(i);
%   echo off;
% end;

%x*c esto m genera q para verificar
