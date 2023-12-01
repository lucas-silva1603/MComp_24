clear all
%--------------------------------------------------------------------------
%
%	Tarefa 20 : calcular a resultante e as reacoes nos apoios
%   	Verificacao do equilibrio estatico	
%   	Reacoes nos apoios com o sistema original obtido apos assemblagem
%	R = Kg*u-fg
%	EST�? NO FIM DESTE CÓDIGO, VER ÚLTIMAS INSTRUÇÕES
%--------------------------------------------------------------------------
%
%	Tarefas 18 e 19 aqui
%	Tarefa 18 : aplicar condicoes de fronteira essenciais homogeneas, u=0
%	Tarefa 19 : aplicar condicoes de fronteira essenciais nao homogeneas, u=10
%
%--------------------------------------------------------------------------
%   Tarefa 17 :	Calculo das matrizes globais para o problema 15c)
%--------------------------------------------------------------------------
%   Definir a Tabela da Conectividade sem usar a funcao delaunay
%  TRI = [1 3 2;3 1 4;5 2 3;4 7 3;6 3 7;3 6 5]	%	conectividade para o no 2 ser o do angulo recto
  TRI = [3 2 1;4 3 1;3 5 2;3 4 7;3 7 6;5 3 6]	%	conectividade arbitraria mas sentido anti-horario
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
%  u=Kg\fg      %  verificar que a matriz e' singular => faltam c. fr.
%  essenciais
%  pause
%--------------------------------------------------------------------------
%	Atencao: Guardar uma copia do sistema original antes de o modificar
Kr= Kg
fr= fg
%   Vamos precisar do sistema original para verificar o equilibrio estatico
%   e Calcular as reacoes nos apoios   
%--------------------------------------------------------------------------
%	formar o sistema equivalente ao sistema reduzido
%	mas sem alterar as suas dimensoes
%--------------------------------------------------------------------------
%
%	Tarefas 18 e 19 aqui
%	Tarefa 18 : aplicar condicoes de fronteira essenciais homogeneas, u=0
%	Tarefa 19 : aplicar condicoes de fronteira essenciais nao homogeneas, u=10
%
%--------------------------------------------------------------------------
boom = 1.0e+12      %   como se adicionasse uma mola de rigidez (quase) infinita
for i=1:Nnds
    if (i ~= 3)		%	restringir aos da fronteira
    %   impor condicoes de fronteira essenciais aqui, linha i
        Kr (i,i) = boom
        fr(i) = boom *10		% o valor pretendido aqui ou e' zero ou 10
    end
end

%	solucao do sistema modificado por backslash
u=Kr\fr
%
%--------------------------------------------------------------------------
%   Verificacao do equilibrio estatico
%	Tarefa 20 : calcular a resultante e as reacoes nos apoios
%   Reacoes nos apoios com o sistema original obtido apos assemblagem
R = Kg*u-fg
%--------------------------------------------------------------------------
