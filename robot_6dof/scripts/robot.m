function [R1, R2, R3] = robot()
close all
clear all
clc
%--------------------------------
% KR 120 R2100 nano F exclusive.
%--------------------------------
dh = [0 0.570 0.300 -pi/2 0;   % Matriz de parámetros de DH.
      0 0     0.900  0    0;
      0 0     0     -pi/2 0;
      0 0.900 0     -pi/2 0;
      0 0     0      pi/2 0;
      0 0.24  0      0    0];
 
R1 = SerialLink(dh,'name','KR 120 R2100 nano F exclusive - 1'); % Robot 1.
q1 = [0,0,0,0,0,0];


R2 = SerialLink(dh,'name','KR 120 R2100 nano F exclusive - 2'); % Robot 2.
q2 = [0,0,0,0,0,0];

R3 = SerialLink(dh,'name','KR 120 R2100 nano F exclusive - 3'); % Robot 3.
q3 = [0,0,0,0,0,0];
% Vector de booleanos en donde se indique qué sistemas de referencia se desean visualizar.

% Rangos de los movimientos.
R1.qlim(1,1:2) = [-165,    165]*pi/180; 
R1.qlim(2,1:2) = [-135, 45]*pi/180; 
R1.qlim(3,1:2) = [-155,     65]*pi/180;
R1.qlim(4,1:2) = [-350,    350]*pi/180;
R1.qlim(5,1:2) = [-125,    125]*pi/180;
R1.qlim(6,1:2) = [-350,    350]*pi/180;

R2.qlim(1,1:2) = [-165,    165]*pi/180; 
R2.qlim(2,1:2) = [-135, 45]*pi/180; 
R2.qlim(3,1:2) = [-155,     65]*pi/180;
R2.qlim(4,1:2) = [-350,    350]*pi/180;
R2.qlim(5,1:2) = [-125,    125]*pi/180;
R2.qlim(6,1:2) = [-350,    350]*pi/180;

R3.qlim(1,1:2) = [-165,    165]*pi/180; 
R3.qlim(2,1:2) = [-135, 45]*pi/180; 
R3.qlim(3,1:2) = [-155,     65]*pi/180;
R3.qlim(4,1:2) = [-350,    350]*pi/180;
R3.qlim(5,1:2) = [-125,    125]*pi/180;
R3.qlim(6,1:2) = [-350,    350]*pi/180;

R1.tool = transl(0,0,0.2);
%R1.offset = [0 -pi/2 0 0 0 0];

R2.base = transl(1,4.2,0)*trotz(-pi/2);
R2.tool = transl(0,0,0.2);
%R2.offset = [0 -pi/2 0 0 0 0];

R3.base = transl(1,6.65,0)*trotz(-pi/2);
R3.tool = transl(0,0,0.2);

%figure()
%R1.plot(q1,'scale',0.5,'jointdiam',0.5,'notiles') % Ploteo del modelo.
%hold on
%R2.plot(q2,'workspace',[-4 4 -4 4 -4 4],'scale',0.5,'jointdiam',0.5,'notiles')
%R1.teach() % Opción para poder mover las articulaciones.
%R2.teach()
end