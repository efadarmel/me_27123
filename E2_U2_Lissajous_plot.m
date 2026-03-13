clc
clear
close all

% Cargar los datos desde el archivo .mat
load('medidas_led.mat')  

Fs = 7680;    % [Hz] Frecuencia de muestreo
fo = 60;      % [Hz] Frecuencia fundamental de la red eléctrica
nSpC = Fs/fo; % Número de muestras por ciclo de la señal
N = 128;      % Número de muestras de la ventana de observación seleccionada
m = 1;        % Número de ciclos de la ventana de observación seleccionada

% 0) Tratamiento de los datos para analizar solamente la ventana de 
% observación seleccionada con N muestras

v_led_1 = v_led_1(1:N);
v_led_2 = v_led_2(1:N);
v_led_3 = v_led_3(1:N);

i_led_1 = i_led_1(1:N);
i_led_2 = i_led_2(1:N);
i_led_3 = i_led_3(1:N);

% Crear el vector de tiempo asociado a las N muestras.
% La duración de un ciclo es To=1/fo [s],y se observa m ciclos. 
% El paso temporal es el periodo de muestreo Ts=1/Fs [s]
t = 0:1/Fs:m/fo-1/Fs;

% Gráficas de las tensiones en función del tiempo
figure
plot(t,v_led_1,'k','LineWidth',2); hold on
plot(t,v_led_2,'r--','LineWidth',2); hold on
plot(t,v_led_3,'b:','LineWidth',2);
grid on
xlim([0 m/fo])
title('Tensiones en la luminaria LED')
ylabel('Tensión [V]')
xlabel('Tiempo [s]')
legend('CO sinusoidal','CO Pointed-Top','CO Flat-Top')

% Gráficas de las corrientes en función del tiempo
figure
plot(t,i_led_1,'k','LineWidth',2); hold on
plot(t,i_led_2,'r--','LineWidth',2); hold on
plot(t,i_led_3,'b:','LineWidth',2)
grid on
xlim([0 m/fo])
title('Corrientes en la luminaria LED')
ylabel('Corriente [A]')
xlabel('Tiempo [s]')
legend('CO sinusoidal','CO Pointed-Top','CO Flat-Top')

% Gráficas de Lissajous (Bowditch)
figure
plot(v_led_1,i_led_1,'k','LineWidth',2); hold on
plot(v_led_2,i_led_2,'r--','LineWidth',2); hold on
plot(v_led_3,i_led_3,'b--','LineWidth',2)
grid on
title('Gráficas de Lissajous - Bowditch')
ylabel('Corriente [A]')
xlabel('Tensión [V]')
legend('CO sinusoidal','CO Pointed-Top','CO Flat-Top')
