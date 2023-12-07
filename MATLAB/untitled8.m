clc
clear

Borders = [1 4 5 0; 2 7 8 0; 3 6 9 0];
Forces = [130 1 2; 140 3 4; 150 5 6];
Number_of_el_walls = size(Borders,1);

% 
for i = 1:Number_of_el_walls 
    no1 = Borders(i,2);
    no2 = Borders(i,end-1);
    Force = 10;   
    % Verificar as coincidências dos nós com as os nós extremo da parede
    no1_in_Wall_Beggining = find(Forces(:, 2) == no1);
    no1_in_Wall_end = find(Forces(:, 3) == no1);
    no2_in_Wall_Beggining = find(Forces(:, 2) == no2);
    no2_in_Wall_end = find(Forces(:, 3) == no2);
   
% Juntar a uma parede
    if any(no1_in_Wall_Beggining) && isempty([no1_in_Wall_end,no2_in_Wall_Beggining,no2_in_Wall_end])
        disp('No 1 Ligado a beg wall')

        % Adicionar força no elemento à força resultante
        Forces(no1_in_Wall_Beggining,1) = Forces(no1_in_Wall_Beggining,1) + Force;
        % Modificar extremos da parede 
        Forces(no1_in_Wall_Beggining,2) = no2;
        

    elseif any(no1_in_Wall_end) && isempty([no1_in_Wall_Beggining,no2_in_Wall_Beggining,no2_in_Wall_end])
        disp('No 1 Ligado a end wall')

        % Adicionar força no elemento à força resultante
        Forces(no1_in_Wall_end,1) = Forces(no1_in_Wall_end,1) + Force;
        % Modificar extremos da parede
        Forces(no1_in_Wall_end,3) = no2;
        

    elseif any(no2_in_Wall_Beggining) && isempty([no1_in_Wall_Beggining,no1_in_Wall_end,no2_in_Wall_end])
        disp('No 2 Ligado a beg wall')

        % Adicionar força no elemento à força resultante
        Forces(no2_in_Wall_Beggining,1) = Forces(no2_in_Wall_Beggining,1) + Force;
        % Modificar extremos da parede 
        Forces(no1_in_Wall_end,2) = no1;


    elseif any(no2_in_Wall_end) && isempty([no1_in_Wall_Beggining,no1_in_Wall_end,no2_in_Wall_end])
        disp('No 2 Ligado a end wall')  

        % Adicionar força no elemento à força resultante
        Forces(no2_in_Wall_end,1) = Forces(no2_in_Wall_end,1) + Force;
        % Modificar extremos da parede 
        Forces(no1_in_Wall_end,3) = no1;
    

    
% Juntar paredes
    elseif any(no1_in_Wall_Beggining) && any(no2_in_Wall_Beggining)
        disp('No 1 Ligado a beg wall No 2 Ligado a Beg wall')

        % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_Beggining,1) = Forces(no1_in_Wall_Beggining,1)+ ...
            Force + Forces(no2_in_Wall_Beggining,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_Beggining,2) = Forces(no2_in_Wall_Beggining,3);
        % Remover uma parede
        Forces(no2_in_Wall_Beggining,:) = [];  
        

    elseif any(no1_in_Wall_Beggining) && any(no2_in_Wall_end)
        disp('No 1 Ligado a beg wall No 2 Ligado a end wall') 

        % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_Beggining,1) = Forces(no1_in_Wall_Beggining,1)+ ...
            Force + Forces(no2_in_Wall_end,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_Beggining,2) = Forces(no2_in_Wall_end,2);
        % Remover uma parede
        Forces(no2_in_Wall_end,:) = [];  


    elseif any(no1_in_Wall_end) && any(no2_in_Wall_Beggining)
        disp('No 1 Ligado a end wall No 2 Ligado a beg wall')

         % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_end,1) = Forces(no1_in_Wall_end,1)+ ...
            Force + Forces(no2_in_Wall_Beggining,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_end,3) = Forces(no2_in_Wall_Beggining,3);
        % Remover uma parede
        Forces(no2_in_Wall_Beggining,:) = []; 


    elseif any(no1_in_Wall_end) && any(no2_in_Wall_end)
        disp('No 1 Ligado a end wall No 2 Ligado a end wall')

        % Somar forças das duas paredes e do elemento
        Forces(no1_in_Wall_end,1) = Forces(no1_in_Wall_end,1)+ ...
            Force + Forces(no2_in_Wall_end,1);

        % Ajustar os extremos da parede nova
        Forces(no1_in_Wall_end,3) = Forces(no2_in_Wall_end,2);
        % Remover uma parede
        Forces(no2_in_Wall_end,:) = []; 

    else
        disp('new wall')
        % Criar nova parede
        Forces(end+1,:) = [Force, no1, no2];
    end 
end % Fim do loop
 Forces