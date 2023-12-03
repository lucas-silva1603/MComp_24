clear
clc

% Importa ficheiro de dados do NX

node_file = fopen('Nodes.txt' ,'r');
element_file = fopen('Elements.txt', 'r');
formatspec = '%c';'%d"';

% Lê dados do ficheiro do NX e extrai informaçao relevante
%
% Nos:

nos = splitlines(fscanf(node_file), formatspec); % Separa o node_file em linhas

filt_nos = [];

for i=11:6:length(nos)

    filt_nos = [filt_nos, nos(i)];

end

col = str2double((filt_nos));  % Separa o ficheiro dos nós em colunas
x=[];
y=[];
n_out=[];

for i=1:1:length(col)
    
    x=[x;col(i,5)];        
    y=[y;col(i,6)];
    n_out=[n_out;i,x(i),y(i)];

end

% n_out contem informção sobre o numero de cada nó e as suas respetivas
% coordenadas

% Elementos:

elementos = splitlines(fscanf(element_file), formatspec); % Separa o element_file em linhas

filt_elem = [];


for i=11:6:length(elementos)

    filt_elem = [filt_elem, elementos(i)]; % Separa o ficheiro dos elementos em colunas

end


% Calculo matriz conectividades


% Propridades do material


% Extração das condições fronteira do ficheiro do NX


% Extração das forças/cargas/fluxo impostos











% Cria (ou abre se já existente) ficheiro dados.txt no diretorio atual


dados = fopen('dados.txt', 'w');

fprintf(dados, '# - Escoamento_Potencial de velocidade\n');


% Adiciona dados extraídos do fichiero do NX ao ficheiro dados.txt



% Escreve as coordenadas dos nós

fprintf(dados, '#Coordenadas dos nos\n');

%fprinft(dados, l)





% Escreve a matriz de conectividades

% Escreve as propriedades do material

% Escreve as fontes e carregamentos distriubidos

% Escreve as condições de fronteira esseciais

% Escreve as fontes e cargas pontuais

% Escreve o fluxo imposto na fronteira (condição de fronteira naturail)

% Escreve a condição de fronteira mista

    















% Fecha o ficheiro dados.txt

fclose(dados);
