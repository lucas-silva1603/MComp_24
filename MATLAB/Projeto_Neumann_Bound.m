function [Kg, fg] = Projeto_Neumann_Bound(Kg, fg, Neumann_Bound)

% Número de condições de Neumann
n = size(Neumann_Bound,1);

    for i=1:n
        % Número dos nó com fluxo imposto
        no1= Neumann_Bound(i,2);
        no2= Neumann_Bound(i,3);

        % Fluxo(gamma)
        gama = Neumann_Bound(i,4);
        
        fg(no1) = fg(no1) + gama/2;
        fg(no2) = fg(no2) + gama/2;        
    end
end
