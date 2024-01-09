function [T_traj] = concatenar_matriz(T_traj1,T_traj2)
    T_traj = zeros(4,4,size(T_traj1,3)+size(T_traj2,3));
    T_traj(:,:,1:size(T_traj1,3)) = T_traj1;
    T_traj(:,:,size(T_traj1,3)+1:end) = T_traj2;
end

