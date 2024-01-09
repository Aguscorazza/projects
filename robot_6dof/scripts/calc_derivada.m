function der = calc_derivada(var,dt)
%Calcula la derivada numérica de la variable var con un paso de tiempo dt
[row, col] = size(var);
der = zeros(size(var));
for c=1:col
    for r=1:row-1
        der(r,c) = (var(r+1,c) - var(r,c))/dt; 
    end
    der(end,c)= (var(end,c) - var(end-1,c))/dt;
end

