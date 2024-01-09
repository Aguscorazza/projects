%En este script se plantea la generación de la trayectoria en base a los
%puntos definidos en el script puntos_trayectoria.m
puntos_trayectoria

dt=0.1; %Cada step corresponde a un diferencial tiempo dt
qd_max = [2 1 2 1 2 2]; %Velocidades articulares máximas


%-----TRAYECTORIA ROBOT 1-----------
%Variables articulares de los diferentes puntos de la trayectoria.
q0 = CinInv(T0, R1, q_ref, 1);
q1 = CinInv(T1, R1, q0, 1);
q2 = CinInv(T2, R1, q1, 0);
q2 = q2(5,:); %Mejor q2 para que el robot no pase por un punto singular q5=0
q3 = CinInv(T3, R1, q2, 1);
q4 = CinInv(T4, R1, q3, 1);


%Interpolación cartesiana entre el punto 0-1 y 1-0:
Ttraj_1 = ctraj(T0,T1,15); % t = 1.5s
%Ttraj_1 = concatenar_matriz(Ttraj_1, ctraj(T1, T0, 10)); %t = 1s
q_traj1 = q_from_interp_cartesiana(Ttraj_1, R1, q0);

%Interpolación articular entre 0-2 con mtraj
via=[q0;
     q2;
     q3];
aux1 = mstraj(via, [], [2 3 2], q1, dt, [1 1 1]);
q_traj1 = concatenar_traj(q_traj1, aux1);
%Interpolación cartesiana entre 2-3, 3-4, 4-3 y 3-2 mediante ctraj:
Ttraj_1 = ctraj(T3, T4, 10); %t = 1s
Ttraj_1 = concatenar_matriz(Ttraj_1, ctraj(T4, T3, 10)); %t = 1s
%Ttraj_1 = concatenar_matriz(Ttraj_1, ctraj(T3, T2, 100)); %t = 1s
aux1 = q_from_interp_cartesiana(Ttraj_1, R1, q_traj1(end,:));

q_traj1 = concatenar_traj(q_traj1, aux1);

%Interpolación articular entre 2-0:
via=[q2;
    q0];
aux1 = mstraj(via, [], [2 4], q3, dt, [0.5 1.5]);

q_traj1 = concatenar_traj(q_traj1, aux1);

qd1 = calc_derivada(q_traj1, dt);
qdd1 = calc_derivada(qd1, dt);


% T_traj1_art = R1.fkine(q_traj1).double;
% x1_art = zeros(1,size(T_traj1_art,3));
% y1_art = zeros(1,size(T_traj1_art,3));
% z1_art = zeros(1,size(T_traj1_art,3));
% %Posición del efector
% for i=1:size(T_traj1_art,3)
%     x1_art(i) = T_traj1_art(1,4,i);
%     y1_art(i) = T_traj1_art(2,4,i);
%     z1_art(i) = T_traj1_art(3,4,i);
% end
% 
% %Cálculo de la velocidad del efector mediante derivación numérica
% [row, col] = size(x1_art);
% v1_x = zeros(size(x1_art));
% v1_y = zeros(size(x1_art));
% v1_z = zeros(size(x1_art));
% v1 = zeros(size(x1_art));
% for c = 1:col-1
%     v1_x(1,c) = (x1_art(1,c+1) - x1_art(1,c))/dt; 
%     v1_y(1,c) = (y1_art(1,c+1) - y1_art(1,c))/dt;
%     v1_z(1,c) = (z1_art(1,c+1) - z1_art(1,c))/dt; 
% end
% %Cálculo del módulo de la velocidad
% for c = 1:col
%     v1(1,c) = sqrt(v1_x(1,c)^2 + v1_y(1,c)^2 + v1_z(1,c)^2);
% end
% 
% %Cálculo de la aceleración del efector mediante derivación numérica
% a1_x = zeros(size(x1_art));
% a1_y = zeros(size(x1_art));
% a1_z = zeros(size(x1_art));
% a1 = zeros(size(x1_art));
% for c = 1:col-1
%     a1_x(1,c) = (v1_x(1,c+1) - v1_x(1,c))/dt; 
%     a1_y(1,c) = (v1_y(1,c+1) - v1_y(1,c))/dt;
%     a1_z(1,c) = (v1_z(1,c+1) - v1_z(1,c))/dt; 
% end
% %Cálculo del módulo de la aceleración
% for c = 1:col
%     a1(1,c) = sqrt(a1_x(1,c)^2 + a1_y(1,c)^2 + a1_z(1,c)^2);
% end
% 
% 
% 
% %Gráficas ROBOT 1
% figure()
% title('Posición articular - ROBOT 1')
% qplot(q_traj1)
% xlabel('')
% grid on
% 
% figure()
% title('Velocidad articular - ROBOT 1')
% qplot(qd1)
% ylabel('Velocidad articular [rad/s]')
% xlabel('')
% grid on
% 
% figure()
% title('Aceleración articular - ROBOT 1')
% qplot(qdd1)
% ylabel('Aceleración articular [rad/s^2]')
% xlabel('')
% grid on
% 
% figure()
% subplot(3,1,1)
% plot(x1_art)
% hold on
% plot(y1_art)
% hold on
% plot(z1_art)
% title('Posición del efector - ROBOT 1')
% legend('x', 'y', 'z')
% grid on
% ylabel('Posición [m]')
% ylim([-0.5 3])
% xlim([0 length(q_traj1)])
% 
% subplot(3,1,2)
% plot(v1)
% title('Velocidad del efector - ROBOT 1')
% grid on
% ylabel('Velocidad [m/s]')
% ylim([-0.5 2.5])
% xlim([0 length(q_traj1)])
% 
% subplot(3,1,3)
% plot(a1)
% title('Aceleración del efector - ROBOT 1')
% grid on
% ylabel('Aceleración [m/s^2]')
% ylim([-0.5 6])
% xlim([0 length(q_traj1)])
% xlabel('k: Steps')

%-----TRAYECTORIA ROBOT 2-----------
%Variables articulares de los diferentes puntos de la trayectoria.
q2_0 = CinInv(T2_0, R2, q_ref, 1);
q2_1 = CinInv(T2_1, R2, q_ref, 1);
q2_2 = CinInv(T2_2, R2, q_ref, 1);
q2_3 = CinInv(T2_3, R2, q_ref, 1);
q2_4 = CinInv(T2_4, R2, q2_3, 1);
q2_5 = CinInv(T2_5, R2, q2_4, 1);
q2_6 = CinInv(T2_6, R2, q2_5, 1);


%Interpolación cartesiana entre el punto 0-1, 1-2, 2-1 y 1-0:
Ttraj_2 = ctraj(T2_0,T2_1,15); % t = 1.5s
Ttraj_2 = concatenar_matriz(Ttraj_2, ctraj(T2_1, T2_2, 15)); %t = 1.5s
Ttraj_2 = concatenar_matriz(Ttraj_2, ctraj(T2_2, T2_1, 15)); %t = 1.5s
Ttraj_2 = concatenar_matriz(Ttraj_2, ctraj(T2_1, T2_0, 15)); %t = 1.5s
q_traj2 = q_from_interp_cartesiana(Ttraj_2, R2, q2_0);

%Interpolación articular entre 0 y 4, con jtraj
aux1= jtraj(q2_0, q2_4, 25); %t=2.5s
q_traj2= concatenar_traj(q_traj2, aux1);


%Interpolación cartesiana entre el punto 4-5, 5-6, 6-5 y 5-4
Ttraj_2 = ctraj(T2_4,T2_5,15); % t = 1.5s
Ttraj_2 = concatenar_matriz(Ttraj_2, ctraj(T2_5, T2_6, 15)); %t = 1.5s
Ttraj_2 = concatenar_matriz(Ttraj_2, ctraj(T2_6, T2_5, 15)); %t = 1.5s
Ttraj_2 = concatenar_matriz(Ttraj_2, ctraj(T2_5, T2_4, 15)); %t = 1.5s
aux1 = q_from_interp_cartesiana(Ttraj_2, R2, q_traj2(end,:));

q_traj2 = concatenar_traj(q_traj2, aux1);

%Interpolación articular entre el punto 4 y 0, usando jtraj
aux1 = jtraj(q2_4, q2_0, 25); %t=2.5s
q_traj2= concatenar_traj(q_traj2, aux1);

qd2 = calc_derivada(q_traj2, dt);
qdd2 = calc_derivada(qd2, dt);

% T_traj2_art = R2.fkine(q_traj2).double;
% x2_art = zeros(1,size(T_traj2_art,3));
% y2_art = zeros(1,size(T_traj2_art,3));
% z2_art = zeros(1,size(T_traj2_art,3));
% 
% %Posición del efector
% for i=1:size(T_traj2_art,3)
%     x2_art(i) = T_traj2_art(1,4,i);
%     y2_art(i) = T_traj2_art(2,4,i);
%     z2_art(i) = T_traj2_art(3,4,i);
% end
% 
% %Cálculo de la velocidad del efector mediante derivación numérica
% [row, col] = size(x2_art);
% v2_x = zeros(size(x2_art));
% v2_y = zeros(size(x2_art));
% v2_z = zeros(size(x2_art));
% v2 = zeros(size(x2_art));
% for c = 1:col-1
%     v2_x(1,c) = (x2_art(1,c+1) - x2_art(1,c))/dt; 
%     v2_y(1,c) = (y2_art(1,c+1) - y2_art(1,c))/dt;
%     v2_z(1,c) = (z2_art(1,c+1) - z2_art(1,c))/dt; 
% end
% %Cálculo del módulo de la velocidad
% for c = 1:col
%     v2(1,c) = sqrt(v2_x(1,c)^2 + v2_y(1,c)^2 + v2_z(1,c)^2);
% end
% 
% %Cálculo de la aceleración del efector mediante derivación numérica
% a2_x = zeros(size(x2_art));
% a2_y = zeros(size(x2_art));
% a2_z = zeros(size(x2_art));
% a2 = zeros(size(x2_art));
% for c = 1:col-1
%     a2_x(1,c) = (v2_x(1,c+1) - v2_x(1,c))/dt; 
%     a2_y(1,c) = (v2_y(1,c+1) - v2_y(1,c))/dt;
%     a2_z(1,c) = (v2_z(1,c+1) - v2_z(1,c))/dt; 
% end
% %Cálculo del módulo de la aceleración
% for c = 1:col
%     a2(1,c) = sqrt(a2_x(1,c)^2 + a2_y(1,c)^2 + a2_z(1,c)^2);
% end
% 
% %Gráficas ROBOT 2
% figure()
% title('Posición articular - ROBOT 2')
% qplot(q_traj2)
% xlabel('')
% grid on
% 
% figure()
% title('Velocidad articular - ROBOT 2')
% qplot(qd2)
% ylabel('Velocidad articular [rad/s]')
% xlabel('')
% grid on
% 
% figure()
% title('Aceleración articular - ROBOT 2')
% qplot(qdd2)
% ylabel('Aceleración articular [rad/s^2]')
% xlabel('')
% grid on
% 
% figure()
% subplot(3,1,1)
% plot(x2_art)
% hold on
% plot(y2_art)
% hold on
% plot(z2_art)
% title('Posición del efector - ROBOT 2')
% legend('x', 'y', 'z')
% grid on
% ylabel('Posición [m]')
% ylim([-1.5 6.5])
% xlim([0 length(q_traj2)])
% 
% subplot(3,1,2)
% plot(v2)
% title('Velocidad del efector - ROBOT 2')
% grid on
% ylabel('Velocidad [m/s]')
% 
% xlim([0 length(q_traj2)])
% 
% subplot(3,1,3)
% plot(a2)
% title('Aceleración del efector - ROBOT 2')
% grid on
% ylabel('Aceleración [m/s^2]')
% xlabel('k: Steps');
% ylim([-0.5 6.5])
% xlim([0 length(q_traj2)])

%-----TRAYECTORIA ROBOT 3-----------
%Variables articulares de los diferentes puntos de la trayectoria.
q3_0 = CinInv(T3_0,R3, q_ref, 1);
q3_1 = CinInv(T3_1,R3, q3_0, 1);
q3_2 = CinInv(T3_2, R3, q3_1, 1);
q3_3 = CinInv(T3_3, R3, q3_2, 1);
q3_4 = CinInv(T3_4, R3, q3_3, 1);

% % %Interpolación cartesiana entre el punto 0-1, 1-2, 2-1:
Ttraj_3 = ctraj(T3_0,T3_1,20); % t = 1.5s
Ttraj_3 = concatenar_matriz(Ttraj_3, ctraj(T3_1, T3_2, 10)); %t = 1.5s
Ttraj_3 = concatenar_matriz(Ttraj_3, ctraj(T3_2, T3_1, 20)); %t = 1.5s
Ttraj_3 = concatenar_matriz(Ttraj_3, ctraj(T3_1, T3_0, 20)); %t = 1.5s
q_traj3 = q_from_interp_cartesiana(Ttraj_3, R3, q3_0);
%Interpolación articular entre 1-3 con 0 como punto intermedio:
aux1 = jtraj(q3_0, q3_3, 30);
q_traj3 = concatenar_traj(q_traj3, aux1);

%Interpolación cartesiana entre 3-4 y 4-3
Ttraj_3 = ctraj(T3_3,T3_4,15); % t = 1.5s
Ttraj_3 = concatenar_matriz(Ttraj_3, ctraj(T3_4, T3_3, 15)); %t = 1.5s
aux1 = q_from_interp_cartesiana(Ttraj_3, R3, q_traj3(end,:));
q_traj3 = concatenar_traj(q_traj3, aux1);

%Interpolación articular entre 3-0
aux1 = jtraj(q3_3, q3_0, 25);
q_traj3= concatenar_traj(q_traj3, aux1);

qd3 = calc_derivada(q_traj3, dt);
qdd3 = calc_derivada(qd3, dt);
% 
% T_traj3_art = R3.fkine(q_traj3).double;
% x3_art = zeros(1,size(T_traj3_art,3));
% y3_art = zeros(1,size(T_traj3_art,3));
% z3_art = zeros(1,size(T_traj3_art,3));
% 
% %Posición del efector
% for i=1:size(T_traj3_art,3)
%     x3_art(i) = T_traj3_art(1,4,i);
%     y3_art(i) = T_traj3_art(2,4,i);
%     z3_art(i) = T_traj3_art(3,4,i);
% end
% 
% %Cálculo de la velocidad del efector mediante derivación numérica
% [row, col] = size(x3_art);
% v3_x = zeros(size(x3_art));
% v3_y = zeros(size(x3_art));
% v3_z = zeros(size(x3_art));
% v3 = zeros(size(x3_art));
% for c = 1:col-1
%     v3_x(1,c) = (x3_art(1,c+1) - x3_art(1,c))/dt; 
%     v3_y(1,c) = (y3_art(1,c+1) - y3_art(1,c))/dt;
%     v3_z(1,c) = (z3_art(1,c+1) - z3_art(1,c))/dt; 
% end
% %Cálculo del módulo de la velocidad
% for c = 1:col
%     v3(1,c) = sqrt(v3_x(1,c)^2 + v3_y(1,c)^2 + v3_z(1,c)^2);
% end
% 
% %Cálculo de la aceleración del efector mediante derivación numérica
% a3_x = zeros(size(x3_art));
% a3_y = zeros(size(x3_art));
% a3_z = zeros(size(x3_art));
% a3 = zeros(size(x3_art));
% for c = 1:col-1
%     a3_x(1,c) = (v3_x(1,c+1) - v3_x(1,c))/dt; 
%     a3_y(1,c) = (v3_y(1,c+1) - v3_y(1,c))/dt;
%     a3_z(1,c) = (v3_z(1,c+1) - v3_z(1,c))/dt; 
% end
% %Cálculo del módulo de la aceleración
% for c = 1:col
%     a3(1,c) = sqrt(a3_x(1,c)^2 + a3_y(1,c)^2 + a3_z(1,c)^2);
% end
% 
% %Gráficas ROBOT 3
% figure()
% title('Posición articular - ROBOT 3')
% qplot(q_traj3)
% xlabel('')
% grid on
% 
% figure()
% title('Velocidad articular - ROBOT 3')
% qplot(qd3)
% ylabel('Velocidad articular [rad/s]')
% xlabel('')
% grid on
% 
% figure()
% title('Aceleración articular - ROBOT 3')
% qplot(qdd3)
% ylabel('Aceleración articular [rad/s^2]')
% xlabel('')
% grid on
% 
% figure()
% subplot(3,1,1)
% plot(x3_art)
% hold on
% plot(y3_art)
% hold on
% plot(z3_art)
% title('Posición del efector - ROBOT 3')
% legend('x', 'y', 'z')
% grid on
% ylabel('Posición [m]')
% ylim([-2 9]);
% xlim([0 length(q_traj3)]);
% 
% subplot(3,1,2)
% plot(v3)
% title('Velocidad del efector - ROBOT 3')
% grid on
% ylabel('Velocidad [m/s]')
% xlim([0 length(q_traj3)]);
% 
% 
% subplot(3,1,3)
% plot(a3)
% title('Aceleración del efector - ROBOT 3')
% grid on
% ylabel('Aceleración [m/s^2]')
% xlim([0 length(q_traj3)]);
% ylim([0 3]);
% xlabel('k: Steps')

W = [-3 5 -3 10 0 5];
view = [-125 20];
figure()
R1.plot3d(q0,'workspace',W,'alpha',1,'path', 'stl\robot1','noname', 'noarrow', 'notiles', 'view', view)
hold on
R2.plot3d(q2_0,'workspace',W,'alpha',1,'path', 'stl\robot2','noname', 'noarrow', 'notiles', 'view', view)
hold on
R3.plot3d(q3_0,'workspace',W,'alpha',1,'path', 'stl\robot3','noname', 'noarrow', 'notiles', 'view', view)
trplot(eye(4)) % Sistema de referencia.
% Plotea las trayectorias una a una 
% R1.plot3d(q_traj1,'workspace',W,'alpha',1,'path', 'stl\robot1','noname', 'noarrow', 'notiles', 'view', view, 'movie', 'anim1.gif', 'noloop')
% R2.plot3d(q_traj2,'workspace',W,'alpha',1,'path', 'stl\robot2','noname', 'noarrow', 'notiles', 'view', view, 'movie', 'anim2.gif', 'noloop')
% R3.plot3d(q_traj3,'workspace',W,'alpha',1,'path', 'stl\robot3','noname', 'noarrow', 'notiles', 'view', view, 'movie', 'anim3.gif', 'noloop')


% DESCOMENTAR SI SE QUIERE REALIZAR UNA ANIMACIÓN DE LAS TRAYECTORIAS
% DE TODOS LOS ROBOTS SIMULTÁNEAMENTE (EL GRÁFICO SE VE LENTO PERO EN EL
% ARCHIVO SE VE BIEN)
% index_1 = 1;
% index_2 = 1;
% index_3 = 1;
% while(1)
%     if index_1 <= size(q_traj1,1)
%          R1.plot3d(q_traj1(index_1,:),'workspace',W,'alpha',1,'path', 'stl\robot1','noname', 'noarrow', 'notiles', 'view', view, 'movie', 'anim.gif')
%     else
%           R1.plot3d(q_traj1(end, :),'workspace',W,'alpha',1,'path', 'stl\robot1','noname', 'noarrow', 'notiles', 'view', view, 'movie', 'anim.gif')
%     end 
%     if index_2 <= size(q_traj2,1)
%         R2.plot3d(q_traj2(index_2,:),'workspace',W,'alpha',1,'path', 'stl\robot2','noname', 'noarrow', 'notiles', 'view', view)
%     else
%         R2.plot3d(q_traj2(end,:),'workspace',W,'alpha',1,'path', 'stl\robot2','noname', 'noarrow', 'notiles', 'view', view)
%     end
%     if index_3 <= size(q_traj3,1)
%          R3.plot3d(q_traj3(index_3,:),'workspace',W,'alpha',1,'path', 'C:\Users\Agustin\Desktop\Trabajo Final Robótica\stl\robot3','noname', 'noarrow', 'notiles', 'view', view)
%     else
%          R3.plot3d(q_traj3(end,:),'workspace',W,'alpha',1,'path', 'C:\Users\Agustin\Desktop\Trabajo Final Robótica\stl\robot3','noname', 'noarrow', 'notiles', 'view', view)
%     end
%     R2.animate(q_traj2(index_2,:))
%     R3.animate(q_traj3(index_3,:))
%      index_1 = index_1 + 1;
%      index_2 = index_2 + 1;
%      index_3 = index_3 + 1;
%     if(index_1 > size(q_traj1,1))
%         index_1 = 1;
%     end
%     if(index_2 > size(q_traj2,1))
%         index_2 = 1;
%     end
%     if(index_3 > size(q_traj3,1))
%         index_3 = 1;
%     end
%       if(index_1 > size(q_traj1,1) && index_2>size(q_traj2,1) && index_3 > size(q_traj3,1))
%           disp("Saliendo")
%           break
%       end
% end