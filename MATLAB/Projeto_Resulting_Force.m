function [Forces] = Projeto_Resulting_Force(p0,p,Neumann_Bound,x,y)
% Calcular Força resultante nas paredes
% [Forces] = [força na parede, início da parede(nó), fim da parede(nó)]


% Filtar os elemento na fronteira dos fluxos impostos diferente de 0 
% guardando numa matriz os resultados
Only_Borders = Neumann_Bound(:, end) == 0;

Borders = Neumann_Bound(Only_Borders, :);

Number_of_el_walls = size(Borders,1);

if isequal(Neumann_Bound,0)
    % Se não houver condições Neuman sair da função
    Number_of_el_walls = 0;
else 
    % Criar a primeira parede
    [Force] = Element_Force(p0,p,Borders(1,:),x,y);
    Forces = [Force, Borders(1,2),Borders(1,end-1)];
end

for i = 2:Number_of_el_walls 
    no1 = Borders(i,2);
    no2 = Borders(i,end-1);
    [Force] = Element_Force(p0,p,Borders(i,:),x,y);
    % Verificar as coincidências dos nós com as os nós extremo da parede
    no1_in_Wall_Beggining = find(Forces(:, 2) == no1);
    no1_in_Wall_end = find(Forces(:, 3) == no1);
    no2_in_Wall_Beggining = find(Forces(:, 2) == no2);
    no2_in_Wall_end = find(Forces(:, 3) == no2);
   
% Juntar a uma parede
    if any(no1_in_Wall_Beggining) && isempty([no1_in_Wall_end,no2_in_Wall_Beggining,no2_in_Wall_end])
        % No 1 ligado ao início de uma parede

        % Adicionar força no elemento à força resultante
        Forces(no1_in_Wall_Beggining,1) = Forces(no1_in_Wall_Beggining,1) + Force;
        % Modificar extremos da parede 
        Forces(no1_in_Wall_Beggining,2) = no2;
        

    elseif any(no1_in_Wall_end) && isempty([no1_in_Wall_Beggining,no2_in_Wall_Beggining,no2_in_Wall_end])
        % No 1 ligado ao fim de uma parede

        % Adicionar força no elemento à força resultante
        Forces(no1_in_Wall_end,1) = Forces(no1_in_Wall_end,1) + Force;
        % Modificar extremos da parede
        Forces(no1_in_Wall_end,3) = no2;
        

    elseif any(no2_in_Wall_Beggining) && isempty([no1_in_Wall_Beggining,no1_in_Wall_end,no2_in_Wall_end])
        % No 2 ligado ao início de uma parede

        % Adicionar força no elemento à força resultante
        Forces(no2_in_Wall_Beggining,1) = Forces(no2_in_Wall_Beggining,1) + Force;
        % Modificar extremos da parede 
        Forces(no1_in_Wall_end,2) = no1;


    elseif any(no2_in_Wall_end) && isempty([no1_in_Wall_Beggining,no1_in_Wall_end,no2_in_Wall_end])
        % No 2 ligado ao fim de uma parede 

        % Adicionar força no elemento à força resultante
        Forces(no2_in_Wall_end,1) = Forces(no2_in_Wall_end,1) + Force;
        % Modificar extremos da parede 
        Forces(no1_in_Wall_end,3) = no1;
    

    
% Juntar paredes
    elseif any(no1_in_Wall_Beggining) && any(no2_in_Wall_Beggining)
        % No 1 ligado ao início de uma parede e o No 2 ligado a início de outra parede

        % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_Beggining,1) = Forces(no1_in_Wall_Beggining,1)+ ...
            Force + Forces(no2_in_Wall_Beggining,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_Beggining,2) = Forces(no2_in_Wall_Beggining,3);
        % Remover uma parede
        Forces(no2_in_Wall_Beggining,:) = [];  
        

    elseif any(no1_in_Wall_Beggining) && any(no2_in_Wall_end)
        % No 1 ligado ao início de uma parede e o No 2 ligado a fim de outra parede 

        % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_Beggining,1) = Forces(no1_in_Wall_Beggining,1)+ ...
            Force + Forces(no2_in_Wall_end,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_Beggining,2) = Forces(no2_in_Wall_end,2);
        % Remover uma parede
        Forces(no2_in_Wall_end,:) = [];  


    elseif any(no1_in_Wall_end) && any(no2_in_Wall_Beggining)
        % No 1 ligado ao fim de uma parede e o No 2 ligado a início de outra parede

         % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_end,1) = Forces(no1_in_Wall_end,1)+ ...
            Force + Forces(no2_in_Wall_Beggining,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_end,3) = Forces(no2_in_Wall_Beggining,3);
        % Remover uma parede
        Forces(no2_in_Wall_Beggining,:) = []; 


    elseif any(no1_in_Wall_end) && any(no2_in_Wall_end)
        % No 1 ligado ao fim de uma parede e o No 2 ligado a início de outra parede

        % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_end,1) = Forces(no1_in_Wall_end,1)+ ...
            Force + Forces(no2_in_Wall_end,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_end,3) = Forces(no2_in_Wall_end,2);
        % Remover uma parede
        Forces(no2_in_Wall_end,:) = []; 

    else
        % Criar nova parede
        Forces(end+1,:) = [Force, no1, no2];
    end 
end % Fim do loop

end % Fim da função

% -------------------------------------------------------------------------

function [Force] = Element_Force(p0,p,Border,x,y)
% Calcular força resultante na parede adjacente ao elemento

if size(Border,2)==4
    % Caso elemento linear
    
    Area = distance([x(Border(2)),y(Border(2))], ...
        [x(Border(3)),y(Border(3))]);
            
elseif size(Border,2) == 5
    % Caso elemento quadrático

Area = distance([x(Border(2)),y(Border(2))], ...
    [x(Border(3)),y(Border(3))]) + ...
    distance([x(Border(4)),y(Border(4))], ...
    [x(Border(3)),y(Border(3))]);           
end

    % Area neste caso é o comprimento da linha do elemento em contacto com a 
    % parede

    % Obter pressão no elemento
p_element = p(Border(1));

Force = Area*(p_element-p0); % Força positiva significa compressão nas paredes 


end % Fim da função