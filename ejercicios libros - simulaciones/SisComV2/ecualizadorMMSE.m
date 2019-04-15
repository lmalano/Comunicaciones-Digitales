function [ cOptimos ] = ecualizadorMMSE(canal,No)
%ECUALIZADORMMSE informacion de la función
%   ecualiza la señal que sale por el filtro receptor para reducir errores

T = 1;
K = -25:25; %51 taps para el ecualizador
M = 10;
Xm = zeros(51,51); % se genera matriz vacia del sistema de ecuaciones
tapCentral = (length(canal)-1)/2 + 1;


for k = K
    for n = K
        m = tapCentral + M*k - n;
        if m <= 0 || m > length(canal)
            Xm(k+26,n+26) = 0;
        else
            Xm(k+26,n+26) = canal(m);
        end
    end
end

Ry = transpose(Xm)*Xm + (No/2)*eye(length(K));
Ray = canal(tapCentral-25:25+tapCentral);

%cOptimos = Ray;

cOptimos = inv(Ry)*transpose(Ray);

%cOptimos = Xm;

end

