function T_total = Transf_Sistemas_Total(R, q)
    q = q + R.offset;
    base = R.base.double;
    tool = R.tool.double;
    T=zeros(4,4*length(q));
    for i=1:length(q)
        %Calcula las matrices de un sistema respecto al siguiente
        T(:,(1+4*(i-1)):(4+4*(i-1)))= Transf_Sistemas(R,i,q(i)); 
    end
    %Calcula la matriz total
    T_total = eye(4);
    for i=1:length(q)
        T_total = T_total * T(:,(1+4*(i-1)):(4+4*(i-1)));
    end
    T_total = base * T_total * tool;
end

