N=500; %largo de la secuencia de informacio
K=5; % 2*k=11
x=[0.05 -0.063 0.088 -0.126 -0.25 0.9047 0.25 0 0.126 0.038 0.088]% 11 muestras del adaptador ecu
sigma=0.001 
delta=0.115
NumIte=1000;
mse_av=zeros(1,N-2*K)

for j=1:NumIte,
    for i=1:N
        if(rand<0.5)
            info(i)=-1;
        else
            info(i)=1;
   end
      
    end % genero simbolos
    
    y=filter(x,1,info);%hago la convolucion con el canal x y los simbolos generados (datos)
            
            cestimado=[0 0 0 0 0 1 0 0 0 0 0]; %uso un c estimado inicial
                for i=1:N-2*K;
                    y_k=y(i:i+2*K);
                    z_k=cestimado*y_k.';
                    e_k=info(i) - z_k;
                    cestimado=cestimado+delta*e_k*y_k;
                    
                    mse(i)=e_k^2;
                    
                end
                
                
                if(j==1); echo on; end
                mse_av=mse_av+mse;
                echo off;
end;
mse_av=mse_av/NumIte;
    
    
    
    