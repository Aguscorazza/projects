function qsol = CinInv(T,R,q,q_mejor)
qsol=zeros(8,6); % Vector articular, hay cuatro soluciones posibles.
T = invHomog(R.base.double) * T;
T = T * invHomog(R.tool.double);
offsets = R.offset;
R.offset = zeros(6,1);
%
%---Cálculo del centro de la muñeca---
%
p = T(1:3,4) - R.d(6) * T(1:3,3);
%
qsol=zeros(8,6); % Vector articular, hay cuatro soluciones posibles.
%
%---Cálculo de tita1---
%
qsol(1,1) = atan2(p(2),p(1));
qsol(2,1) = qsol(1,1);
if qsol(1,1) > 0
    qsol(3,1) = qsol(1,1) - pi;
    qsol(4,1) = qsol(3,1);
end
if qsol(1,1) <= 0
    qsol(3,1) = qsol(1,1) + pi;
    qsol(4,1) = qsol(3,1);
end
%
%---Cálculo de tita2---
%
for i=1:1:2
    T1 = R.links(1).A(qsol(2*i,1)).double;
    pc1 = invHomog(T1) * [p;1];
    r = sqrt(pc1(1)^2+pc1(2)^2);
    beta_2 = atan2(pc1(2),pc1(1));
    L2 = R.links(2).a;
    L3 = R.links(4).d;
    alfa_2 = real(acos((-L2^2+L3^2-r^2)/(-2*L2*r)));
    qsol(2*i-1,2) = beta_2 - alfa_2;
    qsol(2*i,2) = beta_2 + alfa_2;
end
%
%---Cálculo de tita3---
%
for i=1:1:4
    T1 = R.links(1).A(qsol(i,1)).double;
    pc1 = invHomog(T1) * [p;1];
    T2 = R.links(2).A(qsol(i,2)).double;
    pc2 = invHomog(T2) * pc1;
    qsol(i,3) = atan2(pc2(2),pc2(1))- pi/2;
end
%
%---Problema de la orientación---
%
qsol(5:8,1:3) = qsol(1:4,1:3);
%
%---Cálculo de tita4---
%
for i=1:1:4
    T1 = R.links(1).A(qsol(i,1)).double;
    T2 = R.links(2).A(qsol(i,2)).double;
	T3 = R.links(3).A(qsol(i,3)).double;
    T36 = invHomog(T3) * invHomog(T2) * invHomog(T1) * T;
    qsol(i,4) = atan2(T36(2,3),T36(1,3));
    if qsol(i,4) > 0
        qsol(i+4,4) = qsol(i,4) - pi;
    else
        qsol(i+4,4) = qsol(i,4) + pi;
    end
end
%
%---Cálculo de tita5---
%
for i=1:1:8
    T1 = R.links(1).A(qsol(i,1)).double;
    T2 = R.links(2).A(qsol(i,2)).double;
	T3 = R.links(3).A(qsol(i,3)).double;
    T4 = R.links(4).A(qsol(i,4)).double;
    T46 = invHomog(T4) * invHomog(T3) * invHomog(T2) * invHomog(T1) * T;
    qsol(i,5) = atan2(T46(2,3), T46(1,3)) + pi/2;
    T5 = R.links(5).A(qsol(i,5)).double;
    T56 = invHomog(T5) * T46;
    qsol(i,6) = atan2(T56(2,1), T56(1,1));
end
R.offset = offsets;
qsol = qsol - [R.offset;R.offset;R.offset;R.offset;R.offset;R.offset;R.offset;R.offset];
%
%---q mejor---
%
if q_mejor == 1
    Qaux = qsol - [q;q;q;q;q;q;q;q];
    normas = zeros(1,8);
    for i=1:8
        normas(i) = norm(Qaux(i,:));
    end
    minimo = min(normas);
    for i=1:1:8
        if normas(i) == minimo
            pos = i;
        end
    end   
    qsol = qsol(pos,:);
end
%
end


