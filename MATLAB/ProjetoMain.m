clear
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
% -------------------------------------------------------------------------
% Tem solução exata? 0 - não, 1 - sim
exact = 0;
EType = 33;
% -------------------------------------------------------------------------
% teste tri 3
if EType == 33
    x=[0 1 1 0 2 2 1]';
    y=[1 2 1 0 2 1 0]';
    
    elem = [33 1 3 2 1; 33 3 1 4 1;33 5 2 3 1;33 4 7 3 1;33 6 3 7 1;33 3 6 5 1];
    Essential_Boundary = [1 2; 4 3];
    Neumann_Bound = 0;
    Applied_Forces = 0;
    Robin_Bound = [1 5 6 1 1];
end
% -------------------------------------------------------------------------
if EType == 36
    x=[1 0.7071 0 -0.7071 -1 -0.7071 0 0.7071 0.5 0 -0.5 0 0]';
    y=[0 0.7071 1 0.7071 0 -0.7071 -1 -0.7071 0 0.5 0 -0.5 0]';
    elem = [36 1 3 13 2 10 9 4;36 5 13 3 11 10 4 4;36 5 7 13 6 12 11 4;36 7 1 13 8 9 12 4];
    
    Essential_Boundary = 0;
    % Essential_Boundary = zeros(8,2);
    % for i = 1:8
    %     Essential_Boundary(i,1) = i;
    % end
    Neumann_Bound = 0;
    Applied_Forces = 0;
    p=100;
    gama=-2;
    Robin_Bound = [
        1 1 2 3 gama p;
        2 3 4 5 gama p; 
        3 5 6 7 gama p; 
        4 7 8 1 gama p;
        ];
end


% -------------------------------------------------------------------------
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
end
% -------------------------------------------------------------------------
% Cálculo das matrizes rigizez e vetores de força

    % Inicializacao a zeros
Kg = zeros(Nnds,Nnds);
fg = zeros(Nnds,1);

for i=1:Nelt
    % Matriz e vetor de força do elemento
    [Ke, fe, edofs] = Projeto_Elem_Ke_Fe(x,y,elem(i,:),EType);

    % Guardar conectividade do triângulo
    Connectivity(i,:) = edofs;
    % Assemblagem 
    Kg(edofs,edofs)= Kg(edofs,edofs) + Ke; 
    fg(edofs,1)= fg(edofs,1) + fe;       
end

% -------------------------------------------------------------------------
% Aplicação das condições fronteira

    % Forças pontuais
[Kg, fg] = Projeto_Applied_Forces(Kg,fg,Applied_Forces);

    % Condições Neumman
[Kg, fg] = Projeto_Neumann_Bound(Kg,fg,Neumann_Bound);

    % Condições Robin
[Kg, fg] = Projeto_Robin_Bound(Kg,fg,Robin_Bound, x, y, EType);
    
    % Guardar uma copia do sistema já com as condicoes naturais
    % antes de o modificar com as condicoes de fronteira essenciais
Kr= Kg;
fr= fg;

    % Condições essenciais
[Kr, fr] = Projeto_Essential_Bound(Kr,fr,Essential_Boundary);
  
% -------------------------------------------------------------------------
% Obter solução
u=Kr\fr;
R = Kg*u-fg;

% -------------------------------------------------------------------------
% Representação dos resultados
% -------------------------------------------------------------------------
    % Representação potencial
figure(1);
title('Potencial em 2D');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor

% Mudar a ordem conectividade para desenhar os gráficos
if EType == 36
    Connectivity = [Connectivity(:,1) Connectivity(:,4) Connectivity(:,2) Connectivity(:,5) Connectivity(:,3) Connectivity(:,6)]; 
end

patch('Faces', Connectivity, 'Vertices', [x,y], 'FaceVertexCData', u, 'FaceColor', 'interp', 'EdgeColor', 'k');hold;
plot(x,y,'ro');


% -------------------------------------------------------------------------
    % Representação gradiente

[xm,ym,um,vm] = Projeto_Grad(x,y,elem,u);

figure (2);
title('Gradiente');
xlabel('X');
ylabel('Y');

% Desenho da malha
plot (x,y,'ro');hold 

if elem(1,1) == 33 
    triplot([elem(:,2),elem(:,3),elem(:,4)], x, y);
end

quiver (xm,ym,um,vm,'k'); %Desenho do gradiente

% -------------------------------------------------------------------------
    % Representação gradiente com potencial

figure(3);
title('Escoamento');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor

    % Desenho do potencial
patch('Faces', Connectivity, 'Vertices', [x,y], 'FaceVertexCData', u, 'FaceColor', 'interp', 'EdgeColor', 'k');hold;
    % Desenho do gradiente
quiver (xm,ym,um,vm,'k');

% -------------------------------------------------------------------------
% Pressão
ro = 1000;
p = -(elem(:,end)' - 0.5*ro*(um.^2 + vm.^2)); 

    % Representação Pressão(opcional)
figure(4)
title('Pressão');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor

for i = 1:size(Connectivity, 1)
    edofs = Connectivity(i, :);
    element_x = x(edofs);
    element_y = y(edofs);

    patch(element_x, element_y, p(i), 'EdgeColor', 'k');
end
% -------------------------------------------------------------------------
% Imprimir resultados finais
    % Calcular velocidade máxima e mínima e localização
v = sqrt(um.^2 + vm.^2);
vmax = max(v);
v_max_location = (v==vmax);
vmin = min(v);
v_min_location = (v==vmin);

    % Obter pressão máxima e mínima e localização
pmax = max(p);
p_max_location = (p==pmax);
pmin = min(p);
p_min_location = (p==pmin);

    % Imprimir resultados
disp(['Velocidade máxima: ', num2str(vmax), ' em: (', ...
    num2str(xm(v_max_location)), ', ', num2str(ym(v_max_location)), ')']);
disp(['Velocidade mínima: ', num2str(vmin), ' em: (', ...
    num2str(xm(v_min_location)), ', ', num2str(ym(v_min_location)), ')']);
disp(['Pressão máxima: ', num2str(pmax), ' em: (', ...
    num2str(xm(p_max_location)), ', ', num2str(ym(p_max_location)), ')']);
disp(['Pressão mínima: ', num2str(pmin), ' em: (', ...
    num2str(xm(p_min_location)), ', ', num2str(ym(p_min_location)), ')']);


% -------------------------------------------------------------------------
% Se com solução exata comparar erro
if exact == 1

    % solucao exacta
    uex=1-x.^2-y.^2 ; % Valor exato nos nós 

    % Cálculo do erro do potencial
    erru = abs(u - uex);
    
    % Representar erro em 3D
    figure(5)
    trisurf(Connectivity, x, y, erru); grid on 


    % Cálculo da velocidade exata
    umex = 2*xm;
    vmex = 2*ym;

    % Cálculo do erro da velocidade
    errux= um-umex;
    erruy = vm-vmex;
    ergrad =sqrt(errux.^2+erruy.^2);
    
    % Cálculo da pressão exata
    pex = -(elem(:,end)' - 0.5*ro*(umex.^2 + vmex.^2));

    % Cálculo do erro da pressão
    errp = abs(p - pex);
    
    disp(['Erro máximo de potencial: ', num2str(max(erru))]);
    disp(['Erro máximo de velocidade: ', num2str(max(ergrad))]);
    disp(['Erro máximo de pressão: ', num2str(max(errp))]);
end


