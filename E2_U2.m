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
