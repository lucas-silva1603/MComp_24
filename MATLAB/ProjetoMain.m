clear all

% -------------------------------------------------------------------------
% Dados

    % Ler o ficheiro da malha:
[x, y, elem, boundary] = read(file);
    % x - Coordenada x dos nós
    % y - Coordenada y do nós
    % 
    % elem lista de todos elementos 
    % elem = [tipo de elemento no1 no2 no3 fe; tipo de elemento ...]
    % 
    % boundary = 
    % [[Condições essenciais] = nó, valor imposto; nó...
    % [Forças pontuais] = nó, valor da força imposta;
    % [Condições Neumann] = numero do elemento, numero do nó 1, numero do nó2, valor do fluxo
    % [Condições Robin]] = numero do elemento, numero do nó 1, numero do nó2, constante convecção, Temperatura longe da parede

    % Número de nós
Nnds = size(x,1); 

    % Número de elementos
Nelt = size(elem,1); 

% -------------------------------------------------------------------------
% Cálculo das matrizes rigizez e vetores de força

    % Inicializacao a zeros
Kg = zeros(Nnds,Nnds);
fg = zeros(Nnds,1);

for i=1:Nelt
    % Matriz e vetor de força do elemento
    [Ke, fe, edofs] = Projeto_Elem_Ke_Fe(x,y,elem(i,:),elem(i,1));
    
    % Assemblagem 
    Kg(edofs,edofs)= Kg(edofs,edofs) + Ke; 
    fg(edofs,1)= fg(edofs,1) + fe;       
end

% -------------------------------------------------------------------------
% Aplicação das condições fronteira

    % Condições fronteira
    % Forças pontuais
    [Kg, fg] = Projeto_Applied_Forces(Kg,fg,boundary(2));

    % Condições Neumman
    [Kg, fg] = Projeto_Neumann_Bound(Kg,fg,boundary(3));

    % Condições Robin
    [Kg, fg] = Projeto_Robin_Bound(Kg,fg,boundary(4));
    

    % Guardar uma copia do sistema já com as condicoes naturais
    % antes de o modificar com as condicoes de fronteira essenciais
    Kr= Kg;
    fr= fg;

    % Condições essenciais
    [Kr, fr] = Projeto_Essential_Bound(Kr,fr,boundary(1));
  
% -------------------------------------------------------------------------
% Obter solução

% -------------------------------------------------------------------------
% Se com solução exata comparar erro

% -------------------------------------------------------------------------
% Obter gráfico e dados pedidos

