function [Kg, fg] = Projeto_Robin_Bound(Kg, fg, Robin_Bound,x,y, EType)
% Função para aplicar condições fronteira Robin

if Robin_Bound == 0
    % Se não houver condições de fronteira deste tipo passar
else
    % Número de condições de Robin
    n = size(Robin_Bound,1);

    for i=1:n
        if EType ==33         
            % Número dos nós
            no1= Robin_Bound(i,2);
            no2= Robin_Bound(i,3);
            
            % Buscar valor de gama e p
            gama = Robin_Bound(i,4);
            p = Robin_Bound(i,5);
            
            Kg(no1,no1) = Kg(no1,no1) + p/3;
            Kg(no1,no2) = Kg(no1,no2) + p/6;
            Kg(no2,no1) = Kg(no2,no1) + p/6;
            Kg(no2,no2) = Kg(no2,no2) + p/3;
            
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
            p = Robin_Bound(i,6);
            
            % Obter valores a adicionar à matriz de rigidez e ao vetor de forças 
            [He, Pe] = Robin_quadr (x(no1),y(no1),x(no2),y(no2),x(no3),y(no3),p,gama);
            
            %     assemblagem
            Kg(edofs,edofs)= Kg(edofs,edofs) + He; 
            fg(edofs,1)= fg(edofs,1) + Pe;           
        end
        
    end % Fim do loop

end % Fim da condição
end % Fim da função


