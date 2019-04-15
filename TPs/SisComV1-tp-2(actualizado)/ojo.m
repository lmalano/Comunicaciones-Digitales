function [] = ojo(datos,nSimbolos,retardo,NumZeros)
%OJO Summary of this function goes here
%   Detailed explanation goes here

% retardo = 101;
sepSimbolos = NumZeros+1;

for i = 0:nSimbolos-1
    
    ojoIni = round(retardo+sepSimbolos*i-(sepSimbolos/2));
    ojoFin = round(retardo+sepSimbolos*i+(sepSimbolos/2));
    
%     ojoIni = retardo+sepSimbolos*i-(sepSimbolos/2);
%     ojoFin = retardo+sepSimbolos*i+(sepSimbolos/2);
    
    plot(0:sepSimbolos,datos(ojoIni:ojoFin))
    hold on

end
title('Diagrama ojo')

end

