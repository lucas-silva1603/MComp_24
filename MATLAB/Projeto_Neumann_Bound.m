function [Kg, fg] = Projeto_Neumann_Bound(Kg, fg, Neumann_Bound, x, y, EType)

if Neumann_Bound == 0
    % Se não houver condições de fronteira deste tipo passar
else
    % Número de condições de Neumann
    n = size(Neumann_Bound,1);
    
    for i=1:n
        if EType ==33   
            % Número dos nó com fluxo imposto
            no1= Neumann_Bound(i,2);
            no2= Neumann_Bound(i,3);
        
            % Fluxo(gamma)
            gama = Neumann_Bound(i,4);
                        
            fg(no1) = fg(no1) + gama/2;
            fg(no2) = fg(no2) + gama/2;

        elseif EType == 36
            % Número dos nós
            no1= Robin_Bound(i,2);
            no2= Robin_Bound(i,3);
            no3 = Robin_Bound(i,4);
            edofs =[no1 no2 no3]; % Guardar conectividade do lado
        
            % Buscar valor de gama e p
            gama = Robin_Bound(i,5);
            p = 0;

            [He, Pe] = Robin_quadr (x(no1),y(no1),x(no2),y(no2),x(no3),y(no3),p,gama);
            
            %     assemblagem
            Kg(edofs,edofs)= Kg(edofs,edofs) + He; 
            fg(edofs,1)= fg(edofs,1) + Pe;  
        end

    end % Fim da loop

end % Fim da condição
end % Fim da função
