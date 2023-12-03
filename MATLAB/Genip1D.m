function [xi, wi]=Genip1D (nip)
%----------------------------------------------------------------
%   gera regras 1D de Gauss-Legendre
%----------------------------------------------------------------
if (nip == 2)   % 2 pontos, grau 3
    G=sqrt(1.0/3.0);
    xi=[-G G];
    wi=[1 ; 1];
end

if (nip == 3)   % 3 pontos, grau 5
    G=sqrt(0.6);
    xi=[-G 0 G];
    wi=[5 ; 8; 5]/9;
end

end 