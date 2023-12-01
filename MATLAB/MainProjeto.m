clear all
% Ler a malha
x,y,elem,boundary = read(file)
% x - Coordenada x dos nós
% y - Coordenada y do nós
% elem Lista de todos elementos 
% elem = [tipo de elemento no1 no2 no3 fe; tipo de elemento ...]
% boundary = [elemento aplicado tipo de fronteira valores]

Nnds =size(x,1) % Número de nós
Nelt=size(elem,1) % Número de elementos

%   inicializacao a zeros
Kg=zeros(Nnds,Nnds)
fg=zeros(Nnds,1)

% Matrizes e vetor de elementos
    %   ciclo para os elementos
for i=1:Nelt
    no1 = TRI(i,1)
    no2 = TRI(i,2)
    no3 = TRI(i,3)
  edofs =[no1 no2 no3]  %   guardar a conectividade deste triangulo

  %     calculos neste elemento i, P15b)
  [Ke fe]= Elem_TRI (x(no1),y(no1),x(no2),y(no2),x(no3),y(no3),1.0)   % <- carregamento unitario aqui

% Matrizes globais vetor globais
  % Assemblagem 
  Kg(edofs,edofs)= Kg(edofs,edofs) + Ke  % 
  fg(edofs,1)= fg(edofs,1) + fe          % 
end %	ciclo for i

    % Condições fronteira


% Matrizes globais vetor globais

% Obter solução

% Se com solução exata comparar erro

% Obter gráfico e dados pedidos

