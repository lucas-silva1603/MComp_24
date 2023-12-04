clear all
close all
%---------------------------------------------------------------------------
% Representacao grafica de triangulos de 6-nos
% com lados curvos atendendo a curvatura de cada lado
%       Autor: Prof. J. L. M. Fernandes
%---------------------------------------------------------------------------
x=[1 0.7071 0 -0.7071 -1 -0.7071 0 0.7071 0.5 0 -0.5 0 0]';
y=[0 0.7071 1 0.7071 0 -0.7071 -1 -0.7071 0 0.5 0 -0.5 0]';
tri6=[1 3 13 2 10 9; 13 3 5 10 4 11;5 7 13 6 12 11; 7 1 13 8 9 12];
u=1-x.^2-y.^2;
%------------------------------------------------
%	testa a curvatura de cada um dos lados
%------------------------------------------------    
Nelt=size(tri6,1)
for i=1:Nelt
    no1=tri6(i,1)
    no2=tri6(i,2)
    no3=tri6(i,3)
    no4=tri6(i,4)
    no5=tri6(i,5)
    no6=tri6(i,6)
L=0
    % face 1: nos 1-4-2
%      teste de curvatura
    d2x = x(no1)+x(no2)-2*x(no4)
    d2y = y(no1)+y(no2)-2*y(no4)
    cmx = max(abs(d2x),abs(d2y))
if (cmx < 0.2)
        % face 1: nos 1-4-2
    L=L+1
    xx(L)=x(no1)
    yy(L)=y(no1)
    L=L+1
    xx(L)=x(no4)
    yy(L)=y(no4)
else
    csi=-1
    for j=1:8
    b(1)=0.5*csi*(csi-1)
    b(2)=1-csi*csi
    b(3)=0.5*csi*(csi+1)
    L=L+1
% face 1: nos 1-4-2
    xx(L)=b(1)*x(no1)+b(2)*x(no4)+b(3)*x(no2)
    yy(L)=b(1)*y(no1)+b(2)*y(no4)+b(3)*y(no2)
    csi=csi+0.25
    end
end
%   face 2: nos 2-5-3
%      teste de curvatura
    d2x = x(no3)+x(no2)-2*x(no5)
    d2y = y(no3)+y(no2)-2*y(no5)
    cmx = max(abs(d2x),abs(d2y))
if (cmx < 0.2)
%   face 2: nos 2-5-3
    L=L+1
    xx(L)=x(no2)
    yy(L)=y(no2)
    L=L+1
    xx(L)=x(no5)
    yy(L)=y(no5)
else    
    csi=-1
for j=1:8
    b(1)=0.5*csi*(csi-1)
    b(2)=1-csi*csi
    b(3)=0.5*csi*(csi+1)
    L=L+1
% face 2: nos 2-5-3
xx(L)=b(1)*x(no2)+b(2)*x(no5)+b(3)*x(no3)
yy(L)=b(1)*y(no2)+b(2)*y(no5)+b(3)*y(no3)
csi=csi+0.25
end
end
% face 3: nos 3-6-1
%      teste de curvatura
    d2x = x(no3)+x(no1)-2*x(no6)
    d2y = y(no3)+y(no1)-2*y(no6)
    cmx = max(abs(d2x),abs(d2y))
if (cmx < 0.2)
% face 3: nos 3-6-1
    L=L+1
    xx(L)=x(no3)
    yy(L)=y(no3)
    L=L+1
    xx(L)=x(no6)
    yy(L)=y(no6)
else
    csi=-1
for j=1:8
    b(1)=0.5*csi*(csi-1)
    b(2)=1-csi*csi
    b(3)=0.5*csi*(csi+1)
    L=L+1
% face 3: nos 3-6-1
xx(L)=b(1)*x(no3)+b(2)*x(no6)+b(3)*x(no1)
yy(L)=b(1)*y(no3)+b(2)*y(no6)+b(3)*y(no1)
csi=csi+0.25
end
end
uu=1-xx.^2-yy.^2

%fill3 (xx,yy,uu,uu);hold on   % para uma representacao 3D
fill (xx,yy,uu);hold on
plot(xx,yy,'b');
end
plot(x,y,'ro');