function [Ke, fe, edofs] = Projeto_Elem_Ke_Fe(x,y,elem,EType)

% verificar tipo de elemento
if EType == 33
    no1 = elem(2);
    no2 = elem(3);
    no3 = elem(4);
    edofs =[no1 no2 no3];  % Guardar a conectividade deste triangulo

    % Matriz de rigidez e vetor de forças do elemento
    [Ke, fe] = Elem_TRI (x(no1),y(no1),x(no2),y(no2),x(no3),y(no3),elem(end));  
 
    
end

end