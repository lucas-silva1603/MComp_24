clear
clc

% Importa ficheiro de dados do NX

node_file = fopen('Nodes.txt' ,'r');
element_file = fopen('Elements.txt', 'r');
formatspec = '%c';'%d"';

% Lê dados do ficheiro do NX e extrai informaçao relevante
%
% Nos:

nos = splitlines(fscanf(node_file), formatspec);

filt_nos = [];

for i=11:6:length(nos)

    filt_nos = [filt_nos, nos(i)];

end

col = split(filt_nos);
c1=[];
c2=[];
x=[];
y=[];
n_out=[];

for i=1:1:length(col)

    c1=[c1;col(i,5)];
    x=[x;str2double(c1(i))];
    c2=[c2;col(i,6)];    
    y=[y;str2double(c2(i))];
    n_out=[n_out;i,x(i),y(i)];

end

% n_out contem informção sobre o numero de cada nó e as suas respetivas
% coordenadas

% Elementos:

elementos = splitlines(fscanf(element_file), formatspec); 

filt_elem = [];















% Cria (ou abre se já existente) ficheiro dados.txt no diretorio atual

dados = fopen('dados.txt', 'w');

fprintf(dados, '# - Escoamento_Potencial de velocidade\n');

% Adiciona dados extraídos do fichiero do NX ao ficheiro dados.txt

% Adiciona coordenadas dos nós

fprintf(dados, '#Coordenadas dos nos\n');

%fprinft(dados, l)






% Fecha o ficheiro dados.txt

fclose(dados);
