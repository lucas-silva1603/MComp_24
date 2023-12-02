
function [Ke, fe]=Elem_TRI (x1,y1,x2,y2,x3,y3,el)    

%--------------------------------------------------------------------------
% Calcular o dobro da area sinalizada do triangulo
Ae2 = (x2 -x1)*(y3 -y1) -(y2 -y1)*(x3 -x1);
% Calculo da area do triangulo
Ae= Ae2/2;	%	area sinalizada

% Derivadas parciais das funcoes de forma
d1dx = (y2-y3)/Ae2;
d1dy = (x3-x2)/Ae2;
d2dx = (y3-y1)/Ae2;
d2dy = (x1-x3)/Ae2;
d3dx = (y1-y2)/Ae2;
d3dy = (x2-x1)/Ae2;
%--------------------------------------------------------------------------
% Coeficientes do triangulo superior da matriz
Ke(1,1) = (d1dx*d1dx + d1dy*d1dy)*Ae;
Ke(1,2) = (d1dx*d2dx + d1dy*d2dy)*Ae;
Ke(1,3) = (d1dx*d3dx + d1dy*d3dy)*Ae;
Ke(2,2) = (d2dx*d2dx + d2dy*d2dy)*Ae;
Ke(2,3) = (d2dx*d3dx + d2dy*d3dy)*Ae;
Ke(3,3) = (d3dx*d3dx + d3dy*d3dy)*Ae;
% Usar a simetria para obter o triangulo inferior da matriz
Ke(2,1)= Ke(1,2);
Ke(3,1)= Ke(1,3);
Ke(3,2)= Ke(2,3);

%--------------------------------------------------------------------------
% Acrescentar o vector de forcas a seguir
% Vector de forcas:   declarar como vector coluna
fe(1:3,1)= el*Ae/3;     % Para uma carga uniforme de intensidade el

end    