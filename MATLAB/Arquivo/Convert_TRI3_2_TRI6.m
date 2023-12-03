clear all
close all
%-----------------------------------------------------------
%       Tarefa 65 : Converter uma malha de T3 numa de T6 
%-----------------------------------------------------------
%   conversion of triangular meshes to tri-6
x=[1 0 0 0.707107 0 0.5]'
y=[0 1 0 0.707107 0.5 0]'
TRI=[1 4 6;2 5 4;3 6 5;4 5 6] 

figure(1)
Nelt=size(TRI,1)
for i=1: Nelt
no1=TRI(i,1)
no2=TRI(i,2)
no3=TRI(i,3)   
edofs=[no1 no2 no3]
%polyshape (x(edofs)',y(edofs)');hold
fill (x(edofs),y(edofs),'c');hold on
plot(x(edofs),y(edofs),'b');hold on
end
plot(x,y,'ro');

Nnds=size(x,1)
Nels=0
Nfron = Nnds    % freeze number of nodes for later use
for i=1: Nelt
no1=TRI(i,1)
no2=TRI(i,2)
no3=TRI(i,3)  
    % cria novos pontos no lado 1-2
    Nnds= Nnds + 1
    x(Nnds)=(x(no1)+x(no2))/2
    y(Nnds)=(y(no1)+y(no2))/2
    no4 = Nnds
    % cria novos pontos no lado 2-3
    Nnds= Nnds + 1
    x(Nnds)=(x(no3)+x(no2))/2
    y(Nnds)=(y(no3)+y(no2))/2
    no5 = Nnds
    % cria novos pontos no lado 3-1
    Nnds= Nnds + 1
    x(Nnds)=(x(no3)+x(no1))/2
    y(Nnds)=(y(no3)+y(no1))/2
    no6 = Nnds
    Nnds =size(x,1);        % numero de nos dos TRI gerados
%----------- corrigir a posicao dos nos da fronteira aqui -----------------
%            para assegurar ter o raio exactamente r=1
kount=0
for k=1:Nnds
    xx=x(k);
    yy=y(k);
    % calcular o raio
    r =sqrt(xx^2+yy^2);
    if (r > 0.92)  % seleccao dos nos da fronteira feita pelo valor do raio
        %   este no esta na fronteira
        %   corrigir as coordenadas para ter o raio exactamente r=1
        kount=kount+1;
        x(k)=xx/r;
        y(k)=yy/r;
    end
end
    Nels=Nels+1
    %   actualize a lista de TRI
    tri6(i,1)=no1
    tri6(i,2)=no2
    tri6(i,3)=no3
    tri6(i,4)=no4
    tri6(i,5)=no5
    tri6(i,6)=no6
end
%--------------------------------------------------------------------------
%       eliminar nos duplos
%--------------------------------------------------------------------------
[B C status]=unique([x y],'rows','stable');
x=B(:,1);
y=B(:,2);
Nnds=size(x,1);
%--------------------------------------------------------------------------
%       fim de eliminar nos duplos
%--------------------------------------------------------------------------
Nelt=size(TRI,1)

for i=1: Nelt
no1=tri6(i,1)
no2=tri6(i,2)
no3=tri6(i,3)
no4=tri6(i,4)
no5=tri6(i,5)
no6=tri6(i,6)
%   actualize a lista de quads
    tri6(i,1)=status(no1)
    tri6(i,2)=status(no2)
    tri6(i,3)=status(no3)
    tri6(i,4)=status(no4)
    tri6(i,5)=status(no5)
    tri6(i,6)=status(no6)
end


figure
Nels=size(tri6,1)
for i=1: Nels
no1=tri6(i,1)
no2=tri6(i,2)
no3=tri6(i,3)
no4=tri6(i,4)
no5=tri6(i,5)
no6=tri6(i,6)
 
edofs=[no1 no4 no2 no5 no3 no6]
%polyshape (x(edofs)',y(edofs)');hold
fill (x(edofs),y(edofs),'y');hold on
plot(x(edofs),y(edofs),'b');hold on
end
plot(x,y,'ro');