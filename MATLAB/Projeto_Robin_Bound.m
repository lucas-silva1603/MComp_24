function [Kg, fg] = Projeto_Robin_Bound(Kg, fg, Robin_Bound)

if Robin_Bound == 0
    % Se não houver condições de fronteira deste tipo passar
else
    % Número de condições de Robin
    n = size(Robin_Bound,1);
    
        for i=1:n
            % Número dos nóS
            no1= Robin_Bound(i,2);
            no2= Robin_Bound(i,3);
            
            % Fluxo(gamma)
            gama = Robin_Bound(i,4);
            p = Robin_Bound(i,5);
           
            Kg(no1,no1) = Kg(no1,no1) + p/3;
            Kg(no1,no2) = Kg(no1,no2) + p/6;
            Kg(no2,no1) = Kg(no2,no1) + p/6;
            Kg(no2,no2) = Kg(no2,no2) + p/3;
    
            fg(no1) = fg(no1) + gama/2;
            fg(no2) = fg(no2) + gama/2;        
        end
end
end


