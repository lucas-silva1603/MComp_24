function [Forces] = Projeto_Resulting_Force(p0,p,Neumann_Bound,x,y,exact)
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
    Forces = 0;
end

Forces = [0;0;0];

for i = 1:Number_of_el_walls 
    no1 = Borders(i,2);
    no2 = Borders(i,end-1);
    x1 = x(no1);
    y1 = y(no1);
    x2 = x(no2);
    y2 = y(no2);
    [Force] = Element_Force(p0,p,Borders(i,:),x,y);
    
    if exact == 0
        r = 0.25;
        inside_circle = (x1 - 2)^2 + (y1)^2 <= r^2 && (x2 - 2)^2 + (y2)^2 <= r^2;
        if y1 > 0 && ~inside_circle
            % Parede Superior
            Forces(1) = Forces(1) + Force;
        end
        if y1 < 0 && ~inside_circle
            % Parede Inferior
            Forces(2) = Forces(2) + Force;            
        end
    
        if inside_circle
            % Circulo interior
            Forces(3) = Forces(3) + Force;            
        end
    else
        if y1 > 0.125
            % Parede Superior
            Forces(1) = Forces(1) + Force;            
        end
        if y2 < 0.2
            % Parede Inferior
            Forces(2) = Forces(2) + Force;            
        end
    end

end % Fim do loop

end % Fim da função


% -------------------------------------------------------------------------

function [Force] = Element_Force(p0,p,Border,x,y)
% Calcular força resultante na parede adjacente ao elemento

if size(Border,2)==4
    % Caso elemento linear
    
    Area = distanceCalc([x(Border(2)),y(Border(2))], ...
        [x(Border(3)),y(Border(3))]);
            
elseif size(Border,2) == 5
    % Caso elemento quadrático
distance1 = distanceCalc([x(Border(2)),y(Border(2))], ...
    [x(Border(3)),y(Border(3))]);

distance2 = distanceCalc([x(Border(2)),y(Border(2))], ...
    [x(Border(4)),y(Border(4))]); 

distance3 = distanceCalc([x(Border(3)),y(Border(3))], ...
    [x(Border(4)),y(Border(4))]); 


d = sort([distance1,distance2,distance3]); 
Area = d(1) + d(2);

end

    % Area neste caso é o comprimento da linha do elemento em contacto com a 
    % parede

    % Obter pressão no elemento
p_element = p(Border(1));

Force = Area*(p_element-p0); % Força positiva significa compressão nas paredes 

end % Fim da função
% -------------------------------------------------------------------------
function [distance] = distanceCalc(p1,p2)
    distance = sqrt((p1(1)-p2(1))^2+(p1(2)-p2(2))^2);

end