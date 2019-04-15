function [] = ojo(datos,nSimbolos)
%OJO Summary of this function goes here
%   Detailed explanation goes here

retardo = 101;


for i = 0:nSimbolos-1
    
    ojoIni = retardo+10*i-5;
    ojoFin = retardo+10*i+5;
    
    plot(0:10,datos(ojoIni:ojoFin))
    hold on

end
title('Diagrama ojo')

end

