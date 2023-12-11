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
% Dados iniciais (Colocar dados aqui)
EType = 6;
    % Tem solução exata? 0 - não, 1 - sim
exact = 1;

    % Obter dados da malha e condicões fronteira
% [x, y, elem, boundaries] = read(file);

    % Dados para cálculo da pressão (Pascal)
        % Pressão inicial(atmosférica)
p0 = 101325;
        % Densidade do líquido
ro = 1000;
        % Velocidade inicial
% v0 = max(Neumann_Bound(:,end)); %obter velocidade de entrada
v0 = 2;

% -------------------------------------------------------------------------
% teste tri 3
if EType == 3
    x=[0 1 1 0 2 2 1]';
    y=[1 2 1 0 2 1 0]';
    
    elem = [3 1 3 2 1; 3 3 1 4 1;33 5 2 3 1;3 4 7 3 1;3 6 3 7 1;3 3 6 5 1];
    Essential_Boundary = [1 2; 4 3];
    Neumann_Bound = [1 1 2 0; 3 2 3 0];
    Applied_Forces = 0;
    Robin_Bound = [1 5 6 1 1];  
end
% -------------------------------------------------------------------------
if EType == 6
    x=[1 0.7071 0 -0.7071 -1 -0.7071 0 0.7071 0.5 0 -0.5 0 0]';
    y=[0 0.7071 1 0.7071 0 -0.7071 -1 -0.7071 0 0.5 0 -0.5 0]';
    elem = [6 1 3 13 2 10 9 4;6 5 13 3 11 10 4 4;6 5 7 13 6 12 11 4;6 7 1 13 8 9 12 4];
    
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
    % Assume-se que todos os elementos são iguais

    % Matriz de conectividades
if EType == 3
    Connectivity = zeros(Nelt,3);
elseif EType == 6
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

    % Guardar conectividade do triângulo na tabela de conectividades
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
[Kg, fg] = Projeto_Neumann_Bound(Kg,fg,Neumann_Bound, x, y, EType);

    % Condições Robin
[Kg, fg] = Projeto_Robin_Bound(Kg,fg,Robin_Bound, x, y, EType);
    
    % Guardar uma copia do sistema já com as condicoes naturais
    % antes de o modificar com as condicoes de fronteira essenciais
Kr= Kg;
fr= fg;

    % Condições essenciais
[Kr, fr] = Projeto_Essential_Bound(Kr,fr,Essential_Boundary);
  
% -------------------------------------------------------------------------
% Obter resultados

% Obter solução do potencial
u=Kr\fr;

% Obter componentes das velocidades nos centroides
[xm,ym,um,vm] = Projeto_Grad(x,y,elem,u);

% Pressão nos centroides (em pascasl)
p = p0 + 0.5*ro*(v0^2)- 0.5*ro*(um.^2 + vm.^2);

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

    % Cálculo da força resultante nas paredes
[Forces] = Projeto_Resulting_Force(p0,p,Neumann_Bound,x,y);

% -------------------------------------------------------------------------
% Representação dos resultados
% -------------------------------------------------------------------------
    % Mudar a ordem conectividade para desenhar os gráficos para triângulos de
    % 6 nós
if EType == 6
    Connectivity = [Connectivity(:,1) Connectivity(:,4)...
        Connectivity(:,2) Connectivity(:,5) Connectivity(:,3) Connectivity(:,6)]; 
end

% -------------------------------------------------------------------------
    % Representação potencial
figure(1);
title('Potencial em 2D');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor

    % Desenho do potencial
patch('Faces', Connectivity, 'Vertices', [x,y], 'FaceVertexCData', u, 'FaceColor', 'interp', 'EdgeColor', 'k');hold on

    % Desenho dos nós
plot(x,y,'ro');


% -------------------------------------------------------------------------
    % Representação da velocidade
figure (2);
title('Gradiente');
xlabel('X');
ylabel('Y');

    % Desenho da malha
if elem(1,1) == 3 
    triplot([elem(:,2),elem(:,3),elem(:,4)], x, y);hold on
end

    % Desenho dos nós
plot (x,y,'ro');hold on

    %Desenho do gradiente
quiver (xm,ym,um,vm,'k'); 

% -------------------------------------------------------------------------
    % Representação gradiente com potencial

figure(3);
title('Escoamento');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor

    % Desenho do potencial
patch('Faces', Connectivity, 'Vertices', [x,y], 'FaceVertexCData', u, 'FaceColor', 'interp', 'EdgeColor', 'k');hold on
    % Desenho do gradiente
quiver (xm,ym,um,vm,'k');

% -------------------------------------------------------------------------
    % Representação Pressão
figure(4)
title('Pressão');
xlabel('X');
ylabel('Y');
colorbar;  % Legenda de cor
    
    % Desenho da pressão representando a cor por elemento 
for i = 1:size(Connectivity, 1)
    edofs = Connectivity(i, :);
    element_x = x(edofs);
    element_y = y(edofs);

    patch(element_x, element_y, p(i), 'EdgeColor', 'k');
end

% -------------------------------------------------------------------------
% Imprimir resultados finais pedidos
    % Imprimir resultados
disp('Resultados pedidos:')
disp(' ')
disp(['Velocidade máxima: ', num2str(vmax), ' em: (', ...
    num2str(xm(v_max_location)), ', ', num2str(ym(v_max_location)), ')']);
disp(['Velocidade mínima: ', num2str(vmin), ' em: (', ...
    num2str(xm(v_min_location)), ', ', num2str(ym(v_min_location)), ')']);
disp(' ')

disp(['Pressão máxima: ', num2str(pmax), ' em: (', ...
    num2str(xm(p_max_location)), ', ', num2str(ym(p_max_location)), ')']);
disp(['Pressão mínima: ', num2str(pmin), ' em: (', ...
    num2str(xm(p_min_location)), ', ', num2str(ym(p_min_location)), ')']);
disp(' ')

if isequal(Forces,0)
    % Não há paredes rígidas
else
    for i = 1:size(Forces,1)
    
        disp(['A força resultante na parede que vai do ponto (',num2str(x(Forces(i,2))),...
        ', ',num2str(y(Forces(i,2))), ') ao ponto (', num2str(x(Forces(i,3))),', ',...
        num2str(y(Forces(i,3))), ') é ', num2str(Forces(i,1)/1000), 'KN.'])
    end
end

% -------------------------------------------------------------------------
% Se com solução exata comparar erro
if exact == 1

    % Solucao exacta é um retângulo. Como a velocidade inicial é conhecida 
    % (foi retirado do enunciado V = 2,0 m/s) e as paredes superiores e 
    % inferiores são impermeáveis(dv/dn = 0), a velocidade é constante.
    % Sendo assim o potencial é linear. Com potencial à saída igual a 0 e
    % comprimento de retângulo de 1 metro temos u(x) = 2 - 2x
    
    % Valor exato nos nós 
    uex=2 -2*x; 

    % Cálculo do erro do potencial
    erru = abs(u - uex);
    erru_max = max(erru); %Erro absoluto máximo
    erru_max_location = (erru == erru_max);% Localização erro absoluto máximo
    erru_rel_max = erru_max/uex(erru_max_location)*100;% Erro relativo
    
    % Representar erro em 3D
    figure(5)
    trisurf(Connectivity, x, y, erru); grid on 


    % Cálculo da velocidade exata
    umex = 2;
    vmex = 0;
    V = sqrt(um.^2+vm.^2);

    % Cálculo do erro da velocidade
    ergrad = abs(V-umex); %Erro absoluto
    ergrad_max = max(ergrad); %Erro absoluto máximo
    errgrad_rel_max = ergrad_max/umex * 100;% Erro relativo


    % Cálculo da pressão exata
        % Como a velocidade é constante, a pressão também é constante(igual
        % à pressão inicial
    pex = p0;
    
    % Cálculo do erro da pressão
    errp = abs(p - pex); %Erro absoluto
    errp_max = max(errp); %Erro absoluto máximo
    errp_max_rel = errp_max/pex * 100; % Erro relativo

    disp('-----------------------------------------------------------------')
    disp('-----------------------------------------------------------------')
    disp(' ')
    disp('Erros:')
    disp(' ')
    
    disp(['Erro absoluto máximo de potencial: ', num2str(erru_max)]);
    disp(['Erro relativo máximo de potencial: ', num2str(erru_rel_max), '%']);
    disp(' ')

    disp(['Erro absoluto máximo de velocidade: ', num2str(ergrad_max)]);
    disp(['Erro relativo máximo de velocidade: ', num2str(errgrad_rel_max), '%']);
    disp(' ')

    disp(['Erro absoluto máximo de pressão: ', num2str(errp_max)]);
    disp(['Erro relativo máximo de pressão: ', num2str(errp_max_rel), '%']);
end


