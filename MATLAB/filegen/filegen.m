clear
clc

% Importa ficheiro de dados do NX

node_file = fopen('Nodes.txt' ,'r');
element_file = fopen('Elements.txt', 'r');
formatspec = '%c';'%d"';

% Lê dados do ficheiro do NX e extrai informaçao relevante

% Nos:

nos = splitlines(fscanf(node_file, formatspec)); % Separa o node_file em linhas

filt_nos = [];

for i=11:6:length(nos)

    filt_nos = [filt_nos, nos(i)];

end

col = str2double(split(filt_nos'));  % Separa o ficheiro dos nós em colunas

% Inicialização de variáveis

x=[];
y=[];
n_num=[];
n_out=[];

for i=1:1:length(col)
    
    n_num=[n_num;int64(i)];
    x=[x;col(i,5)];        
    y=[y;col(i,6)];
    %n_out=[n_out;i,x(i),y(i)];

end
 
% -----------------------------
n_out=cat(2,n_num,x,y);  % Matriz output com as informações sobre os nós
% -----------------------------

% n_out contem informção sobre o numero de cada nó e as suas respetivas
% coordenadas

% Elementos:

elementos = splitlines(fscanf(element_file, formatspec)); % Separa o element_file em linhas

filt_elem = [];

len = length(elementos) - 4;
for i=17:1:len

    filt_elem = [filt_elem, elementos(i)]; % Separa o ficheiro dos elementos em colunas

end

filt_elem = filt_elem';
check = split(filt_elem);
el_col = str2double(split(filt_elem));  % Separa o ficheiro dos nós em colunas

% Inicialização de variáveis

material = 1; % Não definido no propósito deste programa, apenas como placeholder

element_num=[];
element_material=[];
element_type=[];
n1=[];
n2=[];
n3=[];
n4=[];
n5=[];
n6=[];
el_out=[];

% Verificação do tipo de elemento  (Apenas elmentos triangulares de 3 e 6 nós)

for i=1:1:length(check)
        
        if isequal(string(check(i,4)), 'CTRIA6') == true
            el_col(i,4) = 6;
        elseif isequal(string(check(i,4)), 'CTRIA3') == true
            el_col(i,4) = 3;
            
        end
end

% Calculo matriz conectividades

% Loop de criação da matriz de conectividades para elementos triangulares
% de 3 nós

if isequal(el_col(1,4), 3)

    for i=1:1:length(el_col) == true

    element_num=[element_num;el_col(i,2)];
    element_material=[element_material, material];   
    element_type=[element_type, el_col(i,4)];
    n1=[n1;el_col(i,11)];
    n2=[n2;el_col(i,12)];
    n3=[n3;el_col(i,13)];   

    end

    % -----------------------------
    el_out=cat(2,element_num',element_material', element_type,n1,n2,n3); % Output da matriz de conectividades com informação sobre cada elemento
    % -----------------------------

% Loop de criação da matriz de conectividades para elementos triangulares
% de 6 nós

elseif isequal(el_col(1,4), 6) == true
    
    for i=1:1:length(el_col)

    element_num=[element_num;el_col(i,2)];
    element_material=[element_material, material];   
    element_type=[element_type, el_col(i,4)];
    n1=[n1;el_col(i,11)];
    n2=[n2;el_col(i,12)];
    n3=[n3;el_col(i,13)];
    n4=[n4;el_col(i,14)];
    n5=[n5;el_col(i,15)];
    n6=[n6;el_col(i,16)];

    end

    % -----------------------------
    el_out=cat(2,element_num,element_material', element_type',n1,n2,n3,n4,n5,n6);  % Output da matriz de conectividades com informação sobre cada elemento
    % -----------------------------
 
% Mensagem de erro para elementos não suportados
else
    errordlg('Malha com elementos não suportados. Utilize unicamente malhas com elementos triangulares de 3 ou 6 nós','Erro - Tipo de elemento inválido');    
end


% Propriedades do material
% Fora da area de abrangimento deste programa, pelo que apenas serve para
% compatibilidade com o formato de ficheiro de dados pretendido

% Extração das condições fronteira do ficheiro do NX


% Extração das forças/cargas/fluxo impostos











% Cria (ou abre se já existente) ficheiro dados.txt no diretorio atual


dados = fopen('dados.txt', 'w');

fprintf(dados, '# - Escoamento_Potencial de velocidade\n');


% Adiciona dados extraídos do fichiero do NX ao ficheiro dados.txt



% Escreve as coordenadas dos nós

fprintf(dados, '#Coordenadas dos nos\n');
numnos=length(n_out);
fprintf(dados, num2str(numnos));
fprintf(dados, '\n');

% Escreve a matriz de conectividades

% Escreve as propriedades do material

% Escreve as fontes e carregamentos distriubidos

% Escreve as condições de fronteira esseciais

% Escreve as fontes e cargas pontuais

% Escreve o fluxo imposto na fronteira (condição de fronteira naturail)

% Escreve a condição de fronteira mista

    















% Fecha o ficheiro dados.txt

fclose(dados);
