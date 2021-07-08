clear, clc          %Borro todo lo que haya en el Command window y el Workspace

%Procedo a imnportar los lastos del Excel brindado y armo los gráficos
%solicitados

%Procedo a importar las columnas que voy a utilizar

depth = xlsread('HW1_datos_v2.xlsx','POZO','A3:A9857');                    %Profundidad [m]
gr = xlsread('HW1_datos_v2.xlsx','POZO','D3:D9857');                       %Gamma Ray emitido [GAPI]
dens = xlsread('HW1_datos_v2.xlsx','POZO','E3:E9857');                     %Densidad del la roca [gr/cc]
dts = xlsread('HW1_datos_v2.xlsx','POZO','C3:C9857');                      %Tiempo de tránsito de corte [us/ft] (microsegundos por pie)
dtc = xlsread('HW1_datos_v2.xlsx','POZO','B3:B9857');                      %Tiempo de tránsito compresional [us/ft] (microsegundos por pie)
depth_lab = xlsread('HW1_datos_v2.xlsx','LABORATORIO','B3:B9');            %Profundidad de la muestra ensallada [m]
Eest = xlsread('HW1_datos_v2.xlsx','LABORATORIO','C3:C9');                 %Módulo de Young estático [MPSI]

%Valores para realizar conversiones

us_ft2s_m = (1/304800);              %microsegundos/pie a segundos/metro
gr_c32kg_m3 = 1000;                  %gramo/centímetro cúbico a kilogramo/metro cúbico
mpsi2Pa = 6.89475729*10^9;           %Millón de psi a Pascales

%----------------------PUNTO 1----------------------

subplot(1, 4, 1);                       %Creo una única figura donde estén todos los gráficos, y voy agregando los gráficos a dicha figura repitiendo este comando y cambiando el último valor
plot(gr, depth);
title(['Gamma Ray']);
ylabel('Prof (m)');
xlabel('GR (GAPI)');
set(gca,'ydir', 'reverse');
grid on


subplot(1, 4, 2);
plot(dens, depth, 'r');
title(['Densidad']);
ylabel('Prof (m)');
xlabel('ZDEN [gr/cc]');
set(gca,'ydir', 'reverse');
grid on

subplot(1, 4, 3);
plot(dts, depth, 'c');
title(['Tiempo de tránsito compresional']);
ylabel('Prof (m)');
xlabel('DTSD [us/ft]');
set(gca,'ydir', 'reverse');
grid on

subplot(1, 4, 4);
plot(dtc, depth, 'm');
title(['Tiempo de tránsito de corte']);
ylabel('Prof (m)');
xlabel('DT [us/ft]');
set(gca,'ydir', 'reverse');
grid on

%----------------------PUNTO 2---------------------- 

dtc = dtc.*us_ft2s_m;
dts = dts.*us_ft2s_m;
dens = dens.*gr_c32kg_m3;

Vp = dtc.^(-1);
Vs = dts.^(-1);

%Una vez tenemos las velocidades de onda (de compresión y de corte),
%procedemos a calcular el coeficiente de Poisson y posteriormente el Módulo
%de Elasticidad de la roca para cada profundidad.

%A continuación en vez de escribir la fórmula de poisson en forma de
%fracción, lo hago con el exponente "-1" ya que de lo contrario, "v" en vez
%de quedarme una matriz fila, quedaba una matriz cuadrada, lo cual no tiene
%sentido

Vp_s = (Vp./Vs).^2;
v = (1/2) * ( (Vp_s-2) ).*( (Vp_s-1).^-1 );

%Calculo el Módulo de Elasticidad

E = 2.*dens.*Vs.^2.*(1 + v);

%Gráfica de las Velocidades de compresión y de corte
figure
subplot(1, 2, 1);
plot(Vp, depth, 'c');
title(['Vp']);
ylabel('Prof (m)');
xlabel('Vp [m/s]');
set(gca,'ydir', 'reverse');
grid on

subplot(1, 2, 2);
plot(Vs, depth, 'r');
title(['Vs']);
ylabel('Prof (m)');
xlabel('Vs [m/s]');
set(gca,'ydir', 'reverse');
grid on

%----------------------PUNTO 3----------------------
%Ahora graficamos los resultados obtenidos
figure
subplot(1, 2, 1);
plot(v, depth, 'g');
title(['Coeficioente de Poisson']);
ylabel('Prof (m)');
xlabel('Coeficioente de Poisson');
set(gca,'ydir', 'reverse');
grid on

subplot(1, 2, 2);
plot(E, depth, 'c');
title(['Módulo de Young dinámico']);
ylabel('Prof (m)');
xlabel('E dinámico [Pa]');
set(gca,'ydir', 'reverse');
grid on

%----------------------PUNTO 4----------------------

%Calculamos el módulo de Bulk
K = E.*((3*(1-2.*v)).^-1);

%Calculamos el módulo ded cizalladura 
Mu = E.*((2+2.*v).^-1);

%Ahora graficamos los resultados obtenidos

figure
subplot(1, 2, 1);
plot(K, depth, 'm');
title(['Módulo de Bulk']);
ylabel('Prof (m)');
xlabel('K [Pa]');
set(gca,'ydir', 'reverse');
grid on

subplot(1, 2, 2);
plot(Mu, depth, 'b');
title(['Módulo de Cizalladura']);
ylabel('Prof (m)');
xlabel('Módulo de Cizalladura [Pa]');
set(gca,'ydir', 'reverse');
grid on

%----------------------PUNTO 5----------------------
%ESTE PUNTO NO SUPE RESOLVERLO CON MATLAB, SE PODRÍA HABER RESUELTO
%TRANQUILAMENTE EN EXCEL, PERO COMO EN EL SCRIPT DE PYTHON REALIAZDO POR
%MARCOS SI SE PUDO RESOLVER, DIRECTAMENTE UTILICÉ ESOS RESULTADOS
%SIN EMBARGO NO BORRO EL SCRIPT PARA PODER REVERLO LUEGO



% %Tomo los valores del Módulo dinámico en un intervalo de profundidad cercano a 
% %los valores utilizados en el laboratorio, para poder hacer una comparación
% %más exacta
% 
% depth_=[];
% 
% for i=depth'
%      if 2300 < i & i < 2400;
%         depth_(length(depth_)+1) = i;
%      end
% end
% depth_ = depth_';
% 
% %A continuación creo una matriz columna con los valores del Módulo elástico
% %dinámico que están comprendidos de la profundidad 'depth_'. No logré
% %hacerlo mediante algún script, por lo que yo mismo procedo a seleccionar
% %qué valores del Módulo dinámico voy a utilizar
% 
% E_ = E((9199):(9855));           %Esto lo tuve que calcular a de manera tal de obtener el mismo tamaño de E_ y depth_ 
% 
% %Realizo una interpolación para poder obtener los valores de Módulo
% %elástico dinámico a partir de brindar la profundidad
% 
% E_interp = polyfit(depth_, E_, 1);               %realizo la regresión lineal, el "1" hace que sea lineal
% E_ajuste = polyval(E_interp, depth_);            %evalúo la función interpolación en un intervalo de valores 'depth_'
%                                                  %donde incluyo los valores de profundidad utilizados en el laboratorio
%                                                  %para poder compararlos      
% 
% %------------------------------------------------------------
% % Tomo los valores del Módulo dinámico en un intervalo de profundidad cercano a 
% % los valores utilizados en el laboratorio, para poder hacer una comparación
% % más exacta
% 
% % Procedo a evaluar la función de Módulo dinámico interpolada, en los
% % mismos valores de profundidad utilizados en el laboratorio.
% 
% Eest = Eest.*mpsi2Pa;
% 
% figure
% hold on 
% plot(Eest, depth_lab, 'b*');
% set(gca,'ydir', 'reverse');
% axis([3*10^10 7*10^10 2300 2400]);
% 
% plot(E_ajuste, depth_, '.');
% set(gca,'ydir', 'reverse');

%CON ESTOS DATOS NO LOGRO HACER UNA RELACIÓN ENTRE LOS MÓDULOS ELÁSTICOS
%OBTENIDOS EN LABORATORIO PARA CIERTAS PROFUNDIDADES, Y LOS MÓDULOS
%ELÁSTICOS OBTENIDOS POR GAMMA RAY PARA LOS MISMOS VALORES DE PROFUNDIDAD



%----------------------PUNTO 6----------------------

%Realizo un gráfico comparativo entre las correlaciones mostradas en clase,
%y las obtenidas en este pozo (En este script no logré realizar dicha correlación del 
%Módulo elástico, por lo que utilizo los resultados obtenidos en el script de Python de Marcos)

hold on
xlabel('E dinámico (GPa)');
ylabel('E estático (GPa)');
ylim([0,50]);
xlim([0, 50]);
title('Comparación de aproximacines');

x = [0:1:50];

Eissa_and_Kazi = 0.74*x - 0.82;
Wang_Hard = 1.153*x - 15.2;
Wang_Soft = 0.41*x - 1.06;
Mese_and_Dvorkin = 0.59*x - 0.34;
Aproximacion_nuestra = 0.559*x + 13.1081;

plot(x,Eissa_and_Kazi,'--');
plot(x,Wang_Hard,'--');
plot(x,Wang_Soft,'--');
plot(x,Mese_and_Dvorkin,'--');
plot(x,Aproximacion_nuestra);
legend('Eissa and Kazi', 'Wanh Hard', 'Wang Soft', 'Mese and Dvorking', 'Nuestra aproximacón');
grid on