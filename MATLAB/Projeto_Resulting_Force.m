function [Forces] = Projeto_Resulting_Force(p0,p,Neumann_Bound,x,y)
% Calcular Força resultante nas paredes
% [Forces] = [força na parede, início da parede(nó), fim da parede(nó)]

% Filtar os elemento na fronteira dos fluxos impostos guardando numa matriz
% os resultados

Only_Borders = Neumann_Bound(:, end) == 0;

Borders = Neumann_Bound(Only_Borders, :);

Number_of_el_walls = size(Borders,1);

if isequal(Neumann_Bound,0)
    % Se não houver paredes sair da função
    Number_of_el_walls = 0;
else 
    % Criar a primeira parede
    [Force] = Element_Force(p0,p,Borders(1),x,y);
    Forces = [Force, Borders(2),Borders(end-1)];
end

for i = 2:Number_of_el_walls 
    no1 = Borders(i,2);
    no2 = Borders(i,end-1);
    [Force] = Element_Force(p0,p,Borders(i),x,y);
    
    % Verificar se o nó está ligado a alguma parede
    no1_in_Wall_Beggining = find(any(ismember(Forces(2, :), no1), 2));
    no1_in_Wall_end = find(any(ismember(Forces(3, :), no1), 2));
    no2_in_Wall_Beggining = find(any(ismember(Forces(2, :), no2), 2));
    no2_in_Wall_end = find(any(ismember(Forces(3, :), no2), 2));

end
  


 
end % Fim da função

% -------------------------------------------------------------------------

function [Force] = Element_Force(p0,p,Border,x,y)
% Calcular força resultante na parede adjacente ao elemento

 if size(Border)==4
    % Caso elemento linear
    
    Area = distance([x(Border(2)),y(Border(2))], ...
        [x(Border(3)),y(Border(3))]);
            
elseif size(Border) == 5
    % Caso elemento quadrático

Area = distance([x(Border(2)),y(Border(2))], ...
    [x(Border(3)),y(Border(3))]) + ...
    distance([x(Border(4)),y(Border(4))], ...
    [x(Border(3)),y(Border(3))]);           
 end

 % Obter pressão no elemento
p_element = p(Border(1));

Force = Area*(p_element-p0);

end % Fim da função