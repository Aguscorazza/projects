function [Tinv] = invHomog(T)
    Tinv = [[T(1:3,1:3)';0 0 0] [-T(1:3,1:3)'*T(1:3,4);1]];     
end

