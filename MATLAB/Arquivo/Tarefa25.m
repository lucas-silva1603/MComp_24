clear all
%--------------------------------------------------------------------------
%	Tarefa 25 : Introduzir condicoes de Neumann em toda a fronteira:
%		    1 e 4 gama=-4, em 6 e 5, gama=1, e livre ou isolamento
%		    (tambem e' Neumann) no resto da fronteira
%--------------------------------------------------------------------------
%	Tarefa 21 : calcular o gradiente no centroide dos elementos
%   	representa-lo usando a funcao quiver
%	EST� NO FIM DESTE C�DIGO, VER �LTIMO BLOCO DE INSTRU��ES
%--------------------------------------------------------------------------
%   Definir a Tabela da Conectividade sem usar a funcao delaunay
  TRI = [1 3 2;3 1 4;5 2 3;4 7 3;6 3 7;3 6 5]	%	conectividade para o no 2 ser o do angulo recto
%  TRI = [3 2 1;4 3 1;3 5 2;3 4 7;3 7 6;5 3 6]	%	conectividade arbitraria mas sentido anti-horario
Nelt=size(TRI,1)        % numero de triangulos = 6
%--------------------------------------------------------------------------
%   coordenadas dos nos do P15
x=[0 1 1 0 2 2 1]'
y=[1 2 1 0 2 1 0]'
Nnds =size(x,1)         % numero de nos = 7
%--------------------------------------------------------------------------
%   inicializacao a zeros
Kg=zeros(Nnds,Nnds)
fg=zeros(Nnds,1)	% declarado como vector coluna
%--------------------------------------------------------------------------
%   ciclo para os elementos
for i=1:Nelt
    no1 = TRI(i,1)
    no2 = TRI(i,2)
    no3 = TRI(i,3)
  edofs =[no1 no2 no3]  %   guardar a conectividade deste triangulo

  %     calculos neste elemento i, P15b)
  [Ke fe]= Elem_TRI (x(no1),y(no1),x(no2),y(no2),x(no3),y(no3),1.0)   % <- carregamento unitario aqui

  %     assemblagem do elemento P15c)
  Kg(edofs,edofs)= Kg(edofs,edofs) + Ke  % 
  fg(edofs,1)= fg(edofs,1) + fe          % 
end %	ciclo for i
%--------------------------------------------------------------------------
Kg	%   ver a matriz global e verificar, por favor

fg	%   ver o vector global e verificar, por favor
%--------------------------------------------------------------------------
%	Tarefa 25 : adicionar aqui condicoes de fronteira de Neumann nao
%	nulas
gama = 1	%	aplicar no lado direito do dominio
fg(5) = fg(5) + gama/2
fg(6) = fg(6) + gama/2
%--------------------------------------------------------------------------
%	Tarefa 25: adicionar condicoes de fronteira naturais de Neumann nao
%	nulas
gama = -4	%	aplicar no lado esquerdo do dominio
fg(1) = fg(1) + gama/2
fg(4) = fg(4) + gama/2
%--------------------------------------------------------------------------
%	Atencao: Guardar uma copia do sistema ja com as condicoes naturais
%   antes de o modificar com as condicoes de fronteira essenciais
Kr= Kg
fr= fg
%   Vamos precisar do sistema original para verificar o equilibrio estatico
%   e Calcular as reacoes nos apoios mais adiante na Tarefa 20
%--------------------- Tarefa 25 tambem aqui ------------------------------
%   Verificar que a matriz Kg � singular: experimentar det(Kg) e rank(Kg)
%   J� agora calcular o numero de condicao, cond(Kg) 
%--------------------------------------------------------------------------
%	formar o sistema equivalente ao sistema reduzido
%	mas sem alterar as suas dimensoes
%--------------------------------------------------------------------------
%	aplicar condicoes de fronteira essenciais a seguir
%--------------------- Tarefa 25 tambem aqui ------------------------------
boom = 1.0e+16
for i=1:Nnds
    if (i ~= 3) %   exclui o no interior
%		levantar a indeterminacao aqui
        if (i==4)
        Kr (i,i) = boom
        fr(i) = boom * 0	% 10	% o valor pretendido aqui e zero ou 10
        end
    end
end
%----------------------- fim da Tarefa 25 aqui --------------------------
%	solucao do sistema modificado por backslash
u=Kr\fr
%
%--------------------------------------------------------------------------
%	Tarefa 20 : calcular a resultante e as reacoes nos apoios
%       Triplamente R: Resultante(R), residuo(R) e reacao nos apoios(R)
%   	Verificacao do equilibrio estatico	
%   	Reacoes nos apoios com o sistema apos assemblagem + cond. naturais
R = Kg*u-fg
%--------------------------------------------------------------------------
%
%-------------------------- Tarefa 21 da Aula 6 ---------------------------
%
TRI = [33 1 3 2;33 3 1 4;33 5 2 3;33 4 7 3;33 6 3 7;33 3 6 5]
[xm,ym,um,vm] = Projeto_Grad(x,y,TRI,u);
TRI = [1 3 2;3 1 4;5 2 3;4 7 3;6 3 7;3 6 5]
 % for i=1:Nelt;
 %    no1 = TRI(i,1);
 %    no2 = TRI(i,2);
 %    no3 = TRI(i,3);
 %    %   copia coordenadas
 %    x1=x(no1);
 %    x2=x(no2);
 %    x3=x(no3);
 %    y1=y(no1);
 %    y2=y(no2);
 %    y3=y(no3);
 %    %   calcula centroide
 %    xm(i) = (x1+x2+x3)/3;
 %    ym(i) = (y1+y2+y3)/3;
 %    %
 %    %   calcula vector gradiente no elemento   
 %    Ae2 = (x2 -x1)*(y3 -y1) -(y2 -y1)*(x3 -x1);
 %    %   derivadas parciais das funcoes de forma
 %    d1dx = (y2-y3)/Ae2;
 %    d1dy = (x3-x2)/Ae2;
 %    d2dx = (y3-y1)/Ae2;
 %    d2dy = (x1-x3)/Ae2;
 %    d3dx = (y1-y2)/Ae2;
 %    d3dy = (x2-x1)/Ae2;
 %    %   interpolacao e derivadas
 %    um(i) = -(d1dx*u(no1)+d2dx*u(no2)+d3dx*u(no3));
 %    vm(i) = -(d1dy*u(no1)+d2dy*u(no2)+d3dy*u(no3));
 %    %   sinal negativo para o fluxo
 % end
 figure (1)
 plot (x,y,'ro'); hold
 quiver (xm,ym,um,vm,'k')
 triplot(TRI, x, y);
%---------------------- fim da Tarefa 21 da Aula 6 -----------------------
%   
