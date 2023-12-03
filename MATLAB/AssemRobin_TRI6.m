% clear all
close all
%--------------------------------------------------------------------------
%       Demonstra condicoes de Robin num circulo de raio 1
%--------------------------------------------------------------------------
x=[1 0.7071 0 -0.7071 -1 -0.7071 0 0.7071 0.5 0 -0.5 0 0]'
y=[0 0.7071 1 0.7071 0 -0.7071 -1 -0.7071 0 0.5 0 -0.5 0]'
tri6 = [1 3 13 2 10 9;5 13 3 11 10 4;5 7 13 6 12 11;7 1 13 8 9 12]

Nelt=size(tri6,1)        % numero de triangulos

Nnds =size(x,1)         % numero de nos
%   inicializacao a zeros
Kg=zeros(Nnds,Nnds)
fg=zeros(Nnds,1)

for i=1:Nelt    
    no1=tri6(i,1)
    no2=tri6(i,2)
    no3=tri6(i,3)
    no4=tri6(i,4)
    no5=tri6(i,5)
    no6=tri6(i,6)
  edofs =[no1 no2 no3 no4 no5 no6]  %   conectividade deste triangulo
  XN(1:6,1)=x(edofs)
  XN(1:6,2)=y(edofs)
  %     calculos no elemento
fL= 4.0
[Ke fe]=Elem_TRI6 (XN,fL)
% elem = [36 1 3 13 2 10 9 4;36 5 13 3 11 10 4 4;36 5 7 13 6 12 11 4;36 7 1 13 8 9 12 4];
% [Ke, fe, edofs] = Projeto_Elem_Ke_Fe(x,y,elem(i,:),elem(i,1));

  %     assemblagem
  Kg(edofs,edofs)= Kg(edofs,edofs) + Ke ;  % 
  fg(edofs,1)= fg(edofs,1) + fe  ;        % 
end %for i
%Kg
%fg
%boom=1.0e+16
%for i=1:8
%    Kg(i,i) = boom
%    fg(i,1)= boom*0
%end
%--------------------------------------------------------------------------
%   Tarefa 62 : Assemblagem de H e P, condicoes de Robin, lados curvos
%--------------------------------------------------------------------------
% Atencao: so os lados quadraticos sobre a fronteira
%--------------------------------------------------------------------------
p=100
gama=-2
% [He Pe]=Robin_quadr (x(1),y(1),x(2),y(2),x(3),y(3),p,gama)
% 
% edofs =[1 2 3]  %   conectividade deste lado quadratico
% %     assemblagem
%   Kg(edofs,edofs)= Kg(edofs,edofs) + He  % 
%   fg(edofs,1)= fg(edofs,1) + Pe          % 
Robin_Bound = [1 1 2 3 -2 100];
[Kg, fg] = Projeto_Robin_Bound(Kg, fg, Robin_Bound,x,y, 36);

%--------------------------------------------------------------------------
[He Pe]=Robin_quadr (x(3),y(3),x(4),y(4),x(5),y(5),p,gama)
edofs =[3 4 5]  %   conectividade deste lado quadratico
%     assemblagem
  Kg(edofs,edofs)= Kg(edofs,edofs) + He  % 
  fg(edofs,1)= fg(edofs,1) + Pe          % 
[He Pe]=Robin_quadr (x(5),y(5),x(6),y(6),x(7),y(7),p,gama)
edofs =[5 6 7]  %   conectividade deste lado quadratico
%     assemblagem
  Kg(edofs,edofs)= Kg(edofs,edofs) + He  % 
  fg(edofs,1)= fg(edofs,1) + Pe          % 
[He Pe]=Robin_quadr (x(7),y(7),x(8),y(8),x(1),y(1),p,gama)
edofs =[7 8 1]  %   conectividade deste lado quadratico
%     assemblagem adicional de H e P
  Kg(edofs,edofs)= Kg(edofs,edofs) + He  % 
  fg(edofs,1)= fg(edofs,1) + Pe          %
%--------------------------------------------------------------------------  
%   resolver o sistema  
u=Kg\fg
uex=1-x.^2-y.^2
%pause
umx=max(abs(u))
%-----------------------------------------------------------
%   Tarefa 40 -calcular (gradiente) fluxo nos centroides
%-----------------------------------------------------------
Nelt=size(tri6,1)
psi=zeros(6,1)
figure
plot(x,y,'ro');hold on
for i=1:Nelt
    no1=tri6(i,1)
    no2=tri6(i,2)
    no3=tri6(i,3)
    no4=tri6(i,4)
    no5=tri6(i,5)
    no6=tri6(i,6)
edofs =[no1 no2 no3 no4 no5 no6]  %   conectividade deste triangulo
  XN(1:6,1)=x(edofs)
  XN(1:6,2)=y(edofs)  
csi=1/3
eta=1/3

%   para cada ponto calcular
%----------------------------------------------------------------
[B psi Detj]=Shape_N_Der6 (XN,csi,eta)
%----------------------------------------------------------------
uint = psi'*u(edofs)
xpint = XN'*psi
gradu = B'*u(edofs)
fluxu = -gradu
plot(xpint(1),xpint(2),'bx');hold on
quiver(xpint(1),xpint(2),fluxu(1),fluxu(2));hold on
end

figure
Nelt=size(tri6,1)
for i=1:Nelt
    no1=tri6(i,1)
    no2=tri6(i,2)
    no3=tri6(i,3)
    no4=tri6(i,4)
    no5=tri6(i,5)
    no6=tri6(i,6)
   
%edofs=[tri6(i,1) tri6(i,4) tri6(i,2) tri6(i,5) tri6(i,3) tri6(i,6) tri6(i,1)]
edofs=[tri6(i,1) tri6(i,4) tri6(i,2) tri6(i,5) tri6(i,3) tri6(i,6)]
fill (x(edofs),y(edofs),u(edofs));hold on
plot(x(edofs),y(edofs),'b');hold on
end
plot(x,y,'ro');
umx

% function [He Pe]=Robin_quadr (x1,y1,x2,y2,x3,y3,p,gama)
% %------------- Inicializacoes --------------------------
% b=zeros(3,1)
% He=zeros(3,3)
% Pe=zeros(3,1)
% %-------------------------------------------------------
% nip=3
% [xi wi]=Genip1D (nip)   %   regras 1D Gauss-Legendre
% %-------------------------------------------------------
% %
% for ip=1:nip
%     csi=xi(ip)
%     %   calcula funcoes de forma
%     b(1)=0.5*csi*(csi-1)
%     b(2)=1-csi*csi
%     b(3)=0.5*csi*(csi+1)
%         %   calcula derivadas das funcoes de forma
%     db(1)= csi-0.5
%     db(2)=-2*csi
%     db(3)= csi+0.5
%         %   calcula derivadas de x e de y
% xx= db(1)*x1+db(2)*x2+db(3)*x3
% yy= db(1)*y1+db(2)*y2+db(3)*y3
% %-------------------------------------------------------
% jaco = sqrt(xx^2+yy^2)      %   jacobiano
% %-------------------------------------------------------
% wip =jaco*wi(ip)
% wipp =wip*p
% wipg =wip*gama
% %-------------------------------------------------------
% He = He + wipp*b*b'
% Pe = Pe + wipg*b
% end
% end

function [xi wi]=Genip1D (nip)
%----------------------------------------------------------------
%   gera regras 1D de Gauss-Legendre
%----------------------------------------------------------------
if (nip == 2)   % 2 pontos, grau 3
G=sqrt(1.0/3.0)
xi=[-G G];
wi=[1 ; 1];
end
if (nip == 3)   % 3 pontos, grau 5
G=sqrt(0.6)
xi=[-G 0 G];
wi=[5 ; 8; 5]/9;
end
end

%----------------------------------------------------------------------
%	Tarefa 53 : Elemento quadrático triangular de 6-nós
%----------------------------------------------------------------------
function [Ke fe]=Elem_TRI6 (XN,fL)
%   Matriz XN(6,2) contem as coordenadas locais deste triangulo de 6 nos 
%   inicializar Ke e fe
 Ke = zeros(6,6) ;
 fe = zeros(6,1) ;
%   gerar pontos de integracao
nip = 7 ;
[xp wp]=GenipT (nip) ;

%   percorrer os pontos de integracao
for ip=1:nip
    
csi = xp(ip,1) ;
eta = xp(ip,2) ;
%----------------------------------------------------------------
[B psi Detj]=Shape_N_Der6 (XN,csi,eta) ;
%----------------------------------------------------------------
%   5) peso transformado
wip = wp(ip)*Detj ;
%   6) ponderacao da carga no elemento
wipf = fL*wip ;
%   7) calcular e acumular fe, vector (6x1)
fe = fe + wipf*psi ;
%   10) calcular produto B*B' (6x6), pesar e somar a Ke
Ke = Ke + wip*B*B' ;
%
end     %   fim de ciclo de integracao
end     %   fim de funcao

%--------------------------------------------------------------------------
%	Tarefa 52 : Funcoes de Forma, Derivadas e Jacobiano para elementos
%   quadraticos triangulares de 6-nós
%--------------------------------------------------------------------------
function [B psi Detj]=Shape_N_Der6 (XN,csi,eta)
%----------------------------------------------------------------
%   Matriz XN(6,2) contem as coordenadas locais deste triangulo de 6 nos
%----------------------------------------------------------------
psi=zeros(6,1) ;
%   para cada ponto dado, calcular
%   1) funcoes de forma do tri-6, vector psi (6x1)
psi(1) = (1-csi-eta)*(1-2*csi-2*eta);
psi(2) = csi*(2*csi-1);
psi(3) = eta*(2*eta-1);
psi(4) = 4*(1-csi-eta)*csi;
psi(5) = 4*csi*eta;
psi(6) = 4*(1-csi-eta)*eta;

%   2) derivadas parciais em (csi,eta), Matriz Dpsi(6x2)
Dpsi(1,1) = 4*csi+4*eta-3;
Dpsi(2,1) = 4*csi-1;
Dpsi(3,1) = 0;
Dpsi(4,1) = 4 -8*csi -4*eta;
Dpsi(5,1) = 4*eta;
Dpsi(6,1) = -4*eta;
%
Dpsi(1,2) = 4*csi+4*eta-3;
Dpsi(2,2) = 0;
Dpsi(3,2) = 4*eta-1;
Dpsi(4,2) = -4*csi;
Dpsi(5,2) = 4*csi;
Dpsi(6,2) = 4 -4*csi -8*eta;
%   3) derivadas parciais da matriz jacobiana (2x2) de x e y
jaco = XN'*Dpsi ;
%   4) jacobiano da transformacao
Detj = det(jaco) ;
%   5) derivadas parciais da transformacao inversa (csi,eta) em funcao de
%     (x,y), matriz (2x2)
Invj = inv(jaco) ;
%   6) finalmente a matriz B (6x2) das derivadas parciais das funcoes de 
%      forma em (x,y)
B = Dpsi*Invj ;
%----------------------------------------------------------------
end

%----------------------------------------------------------------------
%	Tarefa 51 : Regras de integracao numérica para triangulos
%   pesquisar: S. Deng quadrature formulas in two dimensions matlab
%----------------------------------------------------------------------
function [xp wp]=GenipT (nip)
% pesquisar: S. Deng quadrature formulas in two dimensions matlab
if (nip == 3)   % regra de 3 pts e grau 2
xp=[0.5 0; 0.5 0.5;0 0.5];   % (3x2)
wp=[1 ; 1; 1]/6;
end
if (nip == 4) % regra de 4 pts e grau 3
xp=[1/3 1/3; 0.2 0.2;0.6 0.2;0.2 0.6]; % (4x2)
wp=[-27 ; 25; 25; 25]/96;
end
if (nip == 6) % regra de 6 pts e grau 4
xp=[0.44594849091597 0.44594849091597 ; % (6x2)
0.44594849091597 0.10810301816807 ;
0.10810301816807 0.44594849091597 ;
0.09157621350977 0.09157621350977 ;
0.09157621350977 0.81684757298046 ;
0.81684757298046 0.09157621350977 ];

wp=[ 0.22338158967801; 0.22338158967801; 0.22338158967801;
 0.10995174365532 ; 0.10995174365532; 0.10995174365532]/2;
end
if (nip == 7) % regra de 7 pts e grau 5
xp=[0.33333333333333 0.33333333333333 ;  % (7x2)
    0.47014206410511 0.47014206410511 ;
    0.47014206410511 0.05971587178977 ;
    0.05971587178977 0.47014206410511 ;
    0.10128650732346 0.10128650732346 ;
    0.10128650732346 0.79742698535309 ; 
    0.79742698535309 0.10128650732346];
wp=[ 0.22500000000000; 0.13239415278851;
 0.13239415278851; 0.13239415278851;
 0.12593918054483; 0.12593918054483;
 0.12593918054483]/2;
end
end

