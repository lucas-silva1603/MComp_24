function [Kr, fr] = Projeto_Essential_Bound(Kr,fr,Essential_Boundary)
% Função para aplicar condições fronteira essenciais 

if Essential_Boundary == 0
    % Se não houver condições de fronteira deste tipo passar
else
    boom = 1.0e+10;
    
    % Número de condições essenciais
    n = size(Essential_Boundary,1);
    
    for i=1:n
        % Número do nó com valor imposto
        no= Essential_Boundary(i,1);
        
        % Valor a impor
        value = Essential_Boundary(i,2);
        
        % Modificar Matriz de rigidez e vetor de forças de acordo
        Kr (no,no) = boom;
        fr(no) = boom *value;         
    end
end
end
