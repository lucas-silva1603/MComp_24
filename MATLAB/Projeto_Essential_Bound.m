function [Kr, fr] = Projeto_Essential_Bound(Kr,fr,Essential_Boundary)

boom = 1.0e+16;

% Número de condições essenciais
n = size(Essential_Boundary,1);

    for i=1:n
        % Número do nó com valor imposto
        no= Essential_Boundary(i,1);

        % Valor a impor
        value = Essential_Boundary(i,2);
        
        Kr (no,no) = boom;
        fr(no) = boom *value;         
    end
end
