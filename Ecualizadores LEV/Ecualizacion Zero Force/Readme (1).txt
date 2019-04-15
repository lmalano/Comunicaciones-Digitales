ip_06_10.m Problema del libro Proakis

ZF_support.m : Contiene canales, calculo de canal discreto equivalente y calculo de coeficientes del ZF.

ZF.mdl, Modelo de simulacion del sistema resuelto en ZF_support, para UpF=4. Para observar impacto de la ISI en las constelaciones de alto orden.

ZF_1.mdl, Modelo de simulacion del sistema resuelto en ZF_support, para UpF=4. Incluye ruido.

ZF_2.mdl, Modelo de simulacion en base a canal discreto equivalente. resuelto en ZF_support, para UpF=4.

ZF_3.mdl, Modelo de simulacion en base a canal discreto equivalente. Resuelto en ZF_support, para UpF=2.

Uso: Abrir alguno de los modelos .mdl y ejecutar. EL modelo dará un error (principalmente porque no se calculó el filtro ecualizador todavia). Sin embargo, los coeficientes de los filtros Tx y Rx quedarán en el prompt de matlab. Luego, ejecutar ZF_support.m observar las gráficas de resultado y luego ejecutar de nuevo el modelo.

