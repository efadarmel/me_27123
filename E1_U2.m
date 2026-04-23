% Cálculo de variables eléctricas en un sistema monofásico a partir de
% muestras de tensión y corriente medidas por un medidor digital.
% Se calculan:
% 1) El valor RMS de las señales de tensión y corriente. 
% 2) El valor RMS de la tensión en la carga. 
% 3) La potencia activa, reactiva y de dimensionamiento entregada 
% por la fuente y su factor de potencia. 
% 4) Estime las pérdidas de potencia y la regulación de tensión del
% circuito ramal dado que lo único que se encuentra conectado es la carga. 

clc        % Limpia la ventana de comandos
clear      % Borra variables del workspace
close all  % Cierra todas las figuras abiertas


% Datos del medidor (muestras de tensión y corriente)
% vs -> tensión en el alimentador [V]
% is -> corriente en el alimentador [A]
is = [-1.764 ; 11.578 ; 1.764 ; -11.578 ; -1.764];
vs = [-0.000 ; 179.605 ; 0.000 ; -179.605 ; -0.000];
% Parámetros del sistema
Fs = 240;      % Frecuencia de muestreo [Hz]
fo = 60;       % Frecuencia fundamental del sistema [Hz]
nSpC = Fs/fo;  % Número de muestras por ciclo
N = nSpC;      % Número de muestras de la ventana de observación más 
% pequeña (m=1 ciclo)

% Resistividad de los conductores
% 5.31 ohm/km * 15 m
r = 5.31*15/1000;

% Resistencias del conductor de fase y neutro
rl = r;
rn = r;


% Se limita el análisis a la ventana de observación más pequeña que se 
% puede seleccionar para calcular correctamente los parámetros de
% tension y corriente, además los de potencia
vs = vs(1:N);
is = is(1:N);

% 1) El valor RMS de las señales de tensión y corriente a partir 
% de muestras discretas
Vsrms = sqrt((1/N)*sum(vs.^2));
Isrms = sqrt((1/N)*sum(is.^2));

% 2) El valor RMS de la tensión en la carga.
% Aplicando la Ley de Tensiones de Kirchhoff: -Vs - Vrl + VL - Vrn = 0
% Despejando la tensión en la carga: VL = Vs - Vrl - Vrn
% Como Vrl = rl*i y Vrn = rn*i
vL = vs - rl*is - rn*is;
VLrms = sqrt((1/N)*sum(vL.^2) );

% Se presentan los resultados en forma tabular para facilitar la lectura
nm_col = {'Parámetros','Unidades'};
Un ={'V','A','V'};
nm_row = {'Valor eficaz de la tensión en el alimentador',['Valor eficaz' ...
    'de la corriente en el alimentador'],['Valor eficaz de la tensión' ...
    'en la carga']};
T = table([Vsrms;Isrms;VLrms],Un','VariableNames',nm_col,RowNames=nm_row);
disp(T)

% 3) La potencia activa, reactiva y de dimensionamiento entregada 
% por el alimentador y su factor de potencia.

% Potencia aparente
Ss = Vsrms*Isrms;

% Potencia activa  (valor medio de la potencia instantánea)
ps = vs.*is; %Potencia instantanea
Ps = (1/N)*(sum(ps));

% Potencia reactiva
Qs = sqrt(Ss.^2-Ps.^2);

% Factor de potencia
fps = Ps/Ss;


% 4) Estime las pérdidas de potencia y la regulación de tensión del
% circuito ramal dado que lo único que se encuentra conectado es la carga. 
% Pérdidas por efecto Joule en el alimentador
Per = (rl+rn)*Isrms^2;

% Regulación de tensión del alimentador
% Expresa la caída relativa entre la tensión de suministro y la 
% tensión en la carga
dV =  100*abs(Vsrms - VLrms)/VLrms;

nm_row = {'Potencia Activa','Potencia aparente',['Potencia' ...
    ' Reactiva'],'Factor de potencia','Pérdidas','Regulación de tensión'};

Un ={'W','VA','VAr','atraso','W','%'};

Tp = table([Ps;Ss;Qs;fps;Per;dV],Un','VariableNames',nm_col,RowNames=nm_row);
disp(Tp)