function [Kg, fg] = Projeto_Applied_Forces(Kg, fg, Applied_Forces)

if Applied_Forces == 0
    % Se não houver condições de fronteira deste tipo passar
else
    % Número de condições essenciais
    n = size(Applied_Forces,1);
    
        for i=1:n
            % Número do nó com força
            no= Applied_Forces(i,1);
    
            % Valor da força
            value = Applied_Forces(i,2);
            
            fg(no) = fg(no) + value;         
        end
end
end