clc

Borders = [1 2 3 0;2 7 8 0];
Forces = [130 1 2; 140 3 4; 150 5 6];
Number_of_el_walls = size(Borders,1);


for i = 1:Number_of_el_walls 
    no1 = Borders(i,2);
    no2 = Borders(i,end-1);
        
    % Verificar se o nó está ligado a alguma parede
    no1_in_Wall_Beggining = find(any(ismember(Forces(:, 2), no1), 1));
    no1_in_Wall_end = find(any(ismember(Forces(:, 3), no1), 1));
    no2_in_Wall_Beggining = find(any(ismember(Forces(:, 2), no2), 1));
    no2_in_Wall_end = find(any(ismember(Forces(:, 3), no2), 1));
    
    % Juntar a um parede
    if any(no1_in_Wall_Beggining) && not(any([no1_in_Wall_end,no2_in_Wall_Beggining,no2_in_Wall_end]))
        disp('No 1 Ligado a beg wall')    
    elseif any(no1_in_Wall_end) && not(any([no1_in_Wall_Beggining,no2_in_Wall_Beggining,no2_in_Wall_end]))
        disp('No 1 Ligado a end wall')
    elseif any(no2_in_Wall_Beggining) && not(any([no1_in_Wall_Beggining,no1_in_Wall_end,no2_in_Wall_end]))
        disp('No 2 Ligado a beg wall')
    elseif any(no2_in_Wall_end) && not(any([no1_in_Wall_Beggining,no1_in_Wall_end,no2_in_Wall_end]))
        disp('No 2 Ligado a end wall')      
    
    
    % Juntar paredes
    elseif any(no1_in_Wall_Beggining) && any(no2_in_Wall_Beggining)
        disp('No 1 Ligado a beg wall No 2 Ligado a Beg wall')    
    elseif any(no1_in_Wall_Beggining) && any(no2_in_Wall_end)
        disp('No 1 Ligado a beg wall No 2 Ligado a end wall')    
    elseif any(no1_in_Wall_end) && any(no2_in_Wall_Beggining)
        disp('No 1 Ligado a end wall No 2 Ligado a beg wall')
    elseif any(no1_in_Wall_end) && any(no2_in_Wall_end)
        disp('No 1 Ligado a end wall No 2 Ligado a end wall')
    else
        disp('new wall')
    end
    

   
end