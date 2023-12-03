function [Ke, fe, edofs] = Projeto_Elem_Ke_Fe(x,y,elem,EType)

% verificar tipo de elemento
display(EType)
if EType == 33
    % Triângulo de 3 nós
    no1 = elem(2);
    no2 = elem(3);
    no3 = elem(4);
    edofs =[no1 no2 no3];  % Guardar a conectividade deste triangulo

    % Matriz de rigidez e vetor de forças do elemento
    [Ke, fe] = Elem_TRI (x(no1),y(no1),x(no2),y(no2),x(no3),y(no3),elem(end));  
 
elseif EType == 36
    % Triângulo de 6 nós

    no1=elem(2);
    no2=elem(3);
    no3=elem(4);
    no4=elem(5);
    no5=elem(6);
    no6=elem(7);
    edofs = [no1 no2 no3 no4 no5 no6]; % Guardar a conectividade deste triangulo
    XN(1:6,1)=x(edofs);
    XN(1:6,2)=y(edofs);
    
    % calculos no elemento
    [Ke, fe] = Elem_TRI6 (XN,elem(end));

end % Fim da condição

end % Fim da função