clear all
close all
M = 16;
N= 2;
%----------------------------------------------------------------
%       Tarefa 1 : Gerar MN+1 pontos num circulo de raio unitario
%----------------------------------------------------------------
alfa=pi/M;
theta = 0;
%   fiadas pares
for i=1:M 
    x(i) = cos(theta);
    y(i) = sin(theta);
     theta = theta + 2*alfa;
end
theta = alfa;
%   fiadas impares
for i=M+1:2*M
    x(i) = 0.5*cos(theta);
    y(i) = 0.5*sin(theta);
    theta = theta + 2*alfa;
end
x(M*N+1) = 0;
y(M*N+1) = 0;
%----------------------------------------------------------------
%       Tarefa 2 : variar a resolucao , aumentar M
%----------------------------------------------------------------
% plot (x,y,'ro');
%hold on
%-----------------------------------------------------
%       Tarefa 3 : Gerar a topologia ou conectividade
%-----------------------------------------------------
%   obter a topologia ou conectividade
TRI = delaunay(x,y);
Nelt= size(TRI);
%---------------------------------------------------
%       Tarefa 4 : Desenhar a malha de triangulos
%---------------------------------------------------
      % triplot(TRI, x, y);
      % hold off
%-----------------------------------------------------------------
%       Tarefa 7 : Definir um campo e representá-lo em perspectiva
%-----------------------------------------------------------------      
      % solucao exacta
      u=1-x.^2-y.^2;
      % figure (2)
%---------------------------------------------------
%       Tarefa 7 : modelo opaco ou modelo de arame
%---------------------------------------------------      
 % trisurf(TRI, x, y, u); grid on     % experimentar cada uma destas à vez
 % trimesh(TRI, x, y, u); grid on     % experimentar cada uma destas à vez
 % figure (3)
%---------------------------------------------------
%       Tarefa 5 : preencher os triangulos com cores
%---------------------------------------------------  
 At = 0;
 for i=1:Nelt
    no1 = TRI(i,1);
    no2 = TRI(i,2);
    no3 = TRI(i,3);
    p(1) = x(no1);
    q(1) = y(no1);
    p(2) = x(no2);
    q(2) = y(no2);
    p(3) = x(no3);
    q(3) = y(no3);
    %   determinante magico = produto externo
   Mdet = (p(2)-p(1))*(q(3)-q(1))-(p(3)-p(1))*(q(2)-q(1));
%---------------------------------------------------
%       Tarefa 8 : acumular as areas dos triangulos
%--------------------------------------------------- 
   At = At + Mdet/2;
   % escolher cores 
    if (mod(i,2) > 0) 
    patch(p,q,'r')      % indice impar
   grid on
    else
        patch(p,q,'w')     % indice par
    end
%---------------------------------------------------
%       Tarefa 9 : calcular a posicao do centroide
%--------------------------------------------------- 
    %   calcula centroide
    xm(i) = (x(no1)+x(no2)+x(no3))/3.;
    ym(i) = (y(no1)+y(no2)+y(no3))/3.;
%       opcional: colocar numero do elemento
txt = horzcat(num2str(i));
text(xm(i),ym(i),txt,'FontSize',10)

%---------------------------------------------------------------
%       Tarefa 10 : calcular o vector gradiente de u
%---------------------------------------------------------------
    %   calcula vector gradiente
    um(i) = -2.*xm(i);
    vm(i) = -2.*ym(i);
 end
      % area do dominio : verificar valor e se converge para pi aumentando
      % a resolucao
 At
%---------------------------------------------------------------
%       Tarefa 10 : representar o vector gradiente usando quiver
%---------------------------------------------------------------
 figure (4)
 plot (x,y,'rx'); hold
 triplot(TRI, x, y);
 plot (xm,ym,'w');
 quiver (xm,ym,um,vm,'k')
 
 figure (5)
 %   primeira fiada par, e a fronteira
for i=1:M-1
    s(1) = x(i+1)-x(i)
    s(2) = y(i+1)-y(i)
    scal = norm(s)
%--------------------------------------------------------------
%       Tarefa 11 : representar o vector tangente usando quiver
%--------------------------------------------------------------    
    %   versor tangente na fronteira
    s=s./scal
%-------------------------------------------------------------
%       Tarefa 12 : representar o vector normal usando quiver
%-------------------------------------------------------------
    %   versor normal na fronteira
    sx(i)=s(1)
    sy(i)=s(2)
    nx(i)=s(2)
    ny(i)=-s(1)
    %   ponto medio no segmento da fronteira
    xn(i) = (x(i+1)+x(i))/2.
    yn(i) = (y(i+1)+y(i))/2.
end
    %   ultimo segmento
    s(1) = x(1)-x(M)
    s(2) = y(1)-y(M)
    scal = norm(s)
    s=s./scal
    nx(M)=s(2)
    ny(M)=-s(1)
    sx(M)=s(1)
    sy(M)=s(2)
    xn(M) = (x(1)+x(M))/2.
    yn(M) = (y(1)+y(M))/2.
 plot (x,y,'ro'); hold on
 triplot(TRI, x, y, 'g');
 plot (xn,yn,'kx'); 
  %     setas a azul, vector tangente, reduzie escala
 quiver (xn,yn,sx,sy,0.2,'k'); hold off

%---------------------------------------------------
%       Tarefa 12 : tracar normal exterior
%---------------------------------------------------
     figure(6)
 plot (x,y,'ro');  hold on
 triplot(TRI, x, y, 'b');
 plot (xn,yn,'bx'); 
 %     setas a preto, normal exterior
quiver (xn,yn,nx,ny,0.5,'k'); 

%---------------------------------------------------
%       Tarefa 13 : tracar isolinhas de um campo
%---------------------------------------------------
figure (7)
plot (x,y,'ro'); hold
triplot(TRI, x, y);
u=1-x.^2-y.^2
      %     isolinhas da solucao exacta
     [CS,h]=tricont(x,y,TRI,u)     %   ir buscar esta funcao à net e copiar para a pasta de trabalho
     clabel(CS,h);
     % area do dominio : verificar valor e se converge para pi aumentando a
     % resolucao
At
 
     