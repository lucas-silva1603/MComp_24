clear all
close all
clc
% -------------------------------------------------------------------------
% Dados

    % Ler o ficheiro da malha:
% [x, y, elem, boundaries] = read(file);
    % x - Coordenada x dos nós
    % y - Coordenada y do nós
    % 
    % elem lista de todos elementos 
    % elem = [tipo de elemento no1 no2 no3 fe; tipo de elemento ...]
    % tipo de elemento: 33 - Tri3; 36 - TRi6; 44 - Quad4; 48 - Quad8
    % 
    % boundaries = 
    % [Condições essenciais] = nó, valor imposto; nó...
    % [Forças pontuais] = nó, valor da força imposta;
    % [Condições Neumann] = numero do elemento, numero do nó 1, numero do nó2, valor do fluxo
    % [Condições Robin]= numero do elemento, numero do nó 1, numero do
    % nó2, constante convecção(gama), Temperatura longe da parede(p)

    % teste
x=[0 1 1 0 2 2 1]';
y=[1 2 1 0 2 1 0]';

elem = [33 1 3 2 1; 33 3 1 4 1;33 5 2 3 1;33 4 7 3 1;33 6 3 7 1;33 3 6 5 1];
Essential_Boundary = [1 2; 4 3];
Neumann_Bound = 0;
Applied_Forces = 0;
Robin_Bound = [1 5 6 1 1];

    % Número de nós
Nnds = size(x,1); 

    % Número de elementos
Nelt = size(elem,1); 
    
    % Tipo de elemento
EType = elem(1,1);

    % Matriz para desenho dos resultados
if EType == 33
    Connectivity = zeros(Nelt,3);
elseif EType == 36
    Connectivity = zeros(Nelt,6);
elseif EType == 44
    Connectivity = zeros(Nelt,4);
elseif EType == 48
    Connectivity = zeros(Nelt,8);
end
% -------------------------------------------------------------------------
% Cálculo das matrizes rigizez e vetores de força

    % Inicializacao a zeros
Kg = zeros(Nnds,Nnds);
fg = zeros(Nnds,1);

for i=1:Nelt
    % Matriz e vetor de força do elemento
    [Ke, fe, edofs] = Projeto_Elem_Ke_Fe(x,y,elem(i,:),elem(i,1));

    % Guardar conectividade do triângulo
    Connectivity(i,:) = edofs;
    % Assemblagem 
    Kg(edofs,edofs)= Kg(edofs,edofs) + Ke; 
    fg(edofs,1)= fg(edofs,1) + fe;       
end

% -------------------------------------------------------------------------
% Aplicação das condições fronteira

    % Condições fronteira
    % Forças pontuais
[Kg, fg] = Projeto_Applied_Forces(Kg,fg,Applied_Forces);

    % Condições Neumman
[Kg, fg] = Projeto_Neumann_Bound(Kg,fg,Neumann_Bound);

    % Condições Robin
[Kg, fg] = Projeto_Robin_Bound(Kg,fg,Robin_Bound);
    
    % Guardar uma copia do sistema já com as condicoes naturais
    % antes de o modificar com as condicoes de fronteira essenciais
Kr= Kg;
fr= fg;

    % Condições essenciais
[Kr, fr] = Projeto_Essential_Bound(Kr,fr,Essential_Boundary);
  
% -------------------------------------------------------------------------
% Obter solução
u=Kr\fr;

% -------------------------------------------------------------------------
% Representação dos resultados
    % Representação potencial
figure(1);
patch('Faces', Connectivity, 'Vertices', [x,y], 'FaceVertexCData', u, 'FaceColor', 'interp', 'EdgeColor', 'k'); hold on;
title('Potencial em 2D');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor
plot(x,y,'ro')

    % Representação gradiente
[xm,ym,um,vm] = Projeto_Grad(x,y,elem,u);

figure (2)
plot (x,y,'ro'); hold on
quiver (xm,ym,um,vm,'k')
title('gradiente');
xlabel('X');
ylabel('Y');

if elem(1,1) == 33 
    triplot([elem(:,2),elem(:,3),elem(:,4)], x, y);
end

    % Representação gradiente com potencial
figure(3);
patch('Faces', Connectivity, 'Vertices', [x,y], 'FaceVertexCData', u, 'FaceColor', 'interp', 'EdgeColor', 'k'); hold on;
title('Escoamento');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor
quiver (xm,ym,um,vm,'k')

% Representaçao Isolinhas

% Representação Pressão(opcional)

% -------------------------------------------------------------------------
% Se com solução exata comparar erro

% -------------------------------------------------------------------------
% Obter gráfico e dados pedidos

