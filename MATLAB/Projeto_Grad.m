function [xm,ym,um,vm] = Projeto_Grad(x,y,elem,u)

n = size(elem,1);

xm = zeros(1,n);
ym = zeros(1,n);
um = zeros(1,n);
vm = zeros(1,n);

for i=1:n

    % verificar tipo de elemento
    if elem(i,1) == 33
        % 33 - Triangular de 3 nós

        no1 = elem(i,2);
        no2 = elem(i,3);
        no3 = elem(i,4);
    
        % Copiar coordenadas
        x1=x(no1);
        x2=x(no2);
        x3=x(no3);
        y1=y(no1);
        y2=y(no2);
        y3=y(no3);
    
        % Calcular centroide
        xm(i) = (x1+x2+x3)/3;
        ym(i) = (y1+y2+y3)/3;
        
        % Calcula vector gradiente no elemento   
        Ae2 = (x2 -x1)*(y3 -y1) -(y2 -y1)*(x3 -x1);
    
        % Derivadas parciais das funcoes de forma
        d1dx = (y2-y3)/Ae2;
        d1dy = (x3-x2)/Ae2;
        d2dx = (y3-y1)/Ae2;
        d2dy = (x1-x3)/Ae2;
        d3dx = (y1-y2)/Ae2;
        d3dy = (x2-x1)/Ae2;
    
        %   interpolacao e derivadas
        um(i) = -(d1dx*u(no1)+d2dx*u(no2)+d3dx*u(no3));
        vm(i) = -(d1dy*u(no1)+d2dy*u(no2)+d3dy*u(no3));
    end
end
