% Ejemplo de cálculo del modelo de Fryze y Budeanu

clc        % Limpia la ventana de comandos
close      % Cierra todas las ventanas de figuras abiertas
clear      % Borra todas las variables del workspace


% Con un sistema de medición digital se toman muestras de las señales de 
% tensión y corriente a la salida del tablero de distribución con una 
% frecuencia de muestreo de 480 Hz y con una frecuencia fundamental de 60 Hz.

% Una carga es conectada a 20 m del tablero de distribución, el conductor 
% de la línea es calibre 12 AWG, con una resistividad de 5,47 [Ω/km] 
% (omitir la inductancia del conductor) y el del neutro es 8 AWG, con una
%  resistividad de 2.15 [Ω/km] (omitir la inductancia del conductor).
 
% Al descargar las primeras diez (10) muestras del medidor digital 
% se obtienen los siguientes vectores de muestras:
vs = [-130.900 -168.291 -107.100 -16.829 130.900 168.291 107.100 16.829 -130.900 -168.291];
is = [-0.776 -6.061 -8.479 -5.558 0.776 6.061 8.479 5.558 -0.776 -6.061];

% --- Parámetros de muestreo ---
Fs = 480;      % Frecuencia de muestreo [Hz]
fo = 60;       % Frecuencia fundamental de la red [Hz]
nSpC = Fs/fo;  % Número de muestras por ciclo
N = nSpC;      % Número de muestras de la ventana de observación

% --- Selección de una ventana de tensión y corriente ---
vs = vs(1:N);   
is = is(1:N);   

% --- Cálculo de resistencias de línea y neutro ---
rl = 5.47*20/1000;   % Resistencia del conductor de línea (Ω)
rn = 2.15*20/1000;   % Resistencia del conductor de neutro (Ω)

% --- Tensión en la carga por LVK ---
vL = vs - rl.*is - rn.*is;

% --- Valores eficaces ---
VLrms = sqrt((1/nSpC)*sum(vL.^2));   % Tensión eficaz en la carga
Vsrms = sqrt((1/nSpC)*sum(vs.^2));   % Tensión eficaz en el alimentador
Isrms = sqrt((1/nSpC)*sum(is.^2));   % Corriente eficaz

% --- Modelo de Fryze el alimentador ---
psn = vs.*is;              % Potencia instantánea 
Ps = (1/N)*sum(psn);       % Valor medio de p[n] → Potencia activa
Ss = Vsrms*Isrms;          % Potencia aparente
Qfs = sqrt(Ss^2 - Ps^2);   % Potencia reactiva de Fryze
fps = Ps/Ss;               % Factor de potencia

% --- Modelo de Budeanu en el alimentador ---
% iBs = [is(N/4+1:end), is(1:N/4)];   % Corriente de Budeanu
iBs = [is(3:8), is(1:2)];   % Corriente de Budeanu
QBs = (1/N)*sum(vs.*iBs);           % Potencia reactiva Budeanu
DBs = sqrt(Ss^2 - Ps^2 - QBs^2);    % Potencia de Distorsión de Budeanu

% --- Modelo de Fryze en la carga ---
pLn = vL.*is;              % Potencia instantánea en la carga
PL = (1/N)*sum(pLn);       % Valor medio de p[n] → Potencia activa
SL = VLrms*Isrms;          % Potencia aparente en la carga
QfL = sqrt(SL^2 - PL^2);   % Potencia reactiva de Fryze en la carga
fpL = PL/SL;               % Factor de potencia de la carga

QBL = (1/N)*sum(vL.*iBs);          % Potencia reactiva Budeanu en la carga
DBL = sqrt(SL^2 - PL^2 - QBL^2);   % Potencia de Distorsión de Budeanu en la carga

% --- Tabla de resultados ---
T = table([Ps;PL],[Ss;SL],[Qfs;QfL],[fps;fpL],[QBs;QBL],[DBs;DBL], ...
    VariableNames={'P','S','Qf','fp','QB','DB'});
disp(T)
