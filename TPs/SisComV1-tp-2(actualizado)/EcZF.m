function [cOptimos] = EcZF(canal,taps)

K = (taps-1)/2;     %ya que se quieren generar 2*K + 1 taps desde -K hasta K
recorrido = -K:K;
T = 1;
M = 2;
tau = T/M;
Xm = zeros(taps,taps);
q = zeros(1,taps);
tapCentral = round(length(q)/2);
q(tapCentral) = 1; %condicion para cero ISI
tapCentral = round(length(canal)/2);




%generacion de la matriz Xm

for i = 0:(taps-1)
    for j = 0:(taps-1)
        
        parametro = tapCentral + K + j -2*i;
        
        if parametro > 0 && parametro <= length(canal)
            Xm(i+1,j+1) = canal(parametro);
        else
            Xm(i+1,j+1) = 0;
        
        
    end
    
end
end
cOptimos = inv(Xm)*transpose(q);

end

