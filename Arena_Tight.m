%Script para obtener el Módulo de elasticidad de la Arena Tight

d_x = xlsread('Datos_Ej_1_arena_tight.xlsx','TRX','D2:D531');       %Importo las deformaciones tanto de
d_y = xlsread('Datos_Ej_1_arena_tight.xlsx','TRX','E2:E531');       % x como de y, y también las tensiones
Tension = xlsread('Datos_Ej_1_arena_tight.xlsx','TRX','C2:C531');

fun_lineal = polyfit(d_x, Tension, 1);      %realizo la regresión lineal, el "1" hace que sea lineal
Y = polyval(fun_lineal, d_x);               %evalpuo la función interpolación en todas las absisas para
                                            %poder comparar los gráficos

%De la funcion 'fun_lineal' obtener la pendiente, que será el módulo de elasticidad
disp ('La recta interpolante es')
fun_lineal

%Grafico los puntos de tensión-deformación y también la función interpolada para poder compararla
%Renombro a los vectores 'Tension' y 'Y' para que se ubiquen mejor en la gráfica
Tablas = Tension;
Interpolacion = Y;

hold on
plot(d_x, Tablas, 'b:');
plot(d_x, Interpolacion);

grid on;            %Activo las 'mallas' del fondo
grid minor;         %Refino las mallas

legend('Tablas', 'Interpolacion');
title('Gráfica comparativa');
xlabel('Deformación');
ylabel('Tensión');


%A continuación calculo el coeficiente de Poisson
%Realizo las sumatorias de las deformaciones en x e y
Sum_d_x = sum(d_x);
Sum_d_y = sum(d_y);

%Realizo el cociente de Deformación transversal sobre axial para obtener el coeficiente de Poisson
v = -Sum_d_y/Sum_d_x;
V = ['El coeficiente de Poisson es = ', num2str(v)];
disp(V)