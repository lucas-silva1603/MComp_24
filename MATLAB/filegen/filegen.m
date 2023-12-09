clear
clc 

% -------
% Filegen
% -------

% --------------------------------------------------------------------------
% Esta função importa os ficheiros 'Nodes.txt', 'Elements.txt' e (boundaries
% and shit) e converte para um ficheiro 'dados.txt', com o formato de dados
% necessário para a função principal da simulação
% --------------------------------------------------------------------------


% Importa ficheiros de dados do NX

node_file = fopen('Nodes.txt' ,'r');
element_file = fopen('Elements.txt', 'r');
formatspec = '%c';'%d"';

%flux_file = fopen('fluxo_imposto.csv','r');
%potencial_file = fopen('potencial_imposto.csv', 'r');

% Lê dados dos ficheiros do NX e extrai informaçao relevante

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
    
    n_num=[n_num;i];
    x=[x;col(i,5)];        
    y=[y;col(i,6)];
    %n_out=[n_out;i,x(i),y(i)];

end
 
% ---------------------------------------------------------------------
% Matriz output com as informações sobre os nós

% -----------------------------
n_out=cat(2,n_num,x,y);  
% -----------------------------

% n_out contem informção sobre o numero de cada nó e as suas respetivas
% coordenadas
% ---------------------------------------------------------------------


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

% Verificação do tipo de elemento  (Apenas elementos triangulares de 3 e 6 nós)

for i=1:1:length(check)
        
        if isequal(string(check(i,4)), 'CTRIA6') == true  
            % Triangulo de 6 nos
            el_col(i,4) = 6;
        elseif isequal(string(check(i,4)), 'CTRIA3') == true
            % Triangulo de 3 nos
            el_col(i,4) = 3;            
        end
end

% Calculo matriz conectividades

% Loop de criação da matriz de conectividades para elementos triangulares
% de 3 nós

if isequal(el_col(1,4), 3)

    for i=1:1:length(el_col)

    element_num=[element_num;el_col(i,2)];
    element_material=[element_material, material];   
    element_type=[element_type, el_col(i,4)];
    n1=[n1;el_col(i,11)];
    n2=[n2;el_col(i,12)];
    n3=[n3;el_col(i,13)];   

    end

    % Output da matriz de conectividades com informação sobre cada elemento
    % -----------------------------
    el_out=cat(2,element_num,element_material', element_type',n1,n2,n3); 
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

    % Output da matriz de conectividades com informação sobre cada elemento
    % -----------------------------
    el_out=cat(2,element_num,element_material', element_type',n1,n2,n3,n4,n5,n6);  
    % -----------------------------
 
% Mensagem de erro para elementos não suportados
else
    errordlg('Malha com elementos não suportados. Utilize unicamente malhas com elementos triangulares de 3 ou 6 nós','Erro - Tipo de elemento inválido');    
end



% Propriedades do material

% -----------------------------------------------------------------------
% Fora da area de abrangimento deste programa, pelo que apenas serve para
% compatibilidade com o formato de ficheiro de dados pretendido
% -----------------------------------------------------------------------

numero_materiais = 1;
ident_mat = 1;
prop_material = double(1);

% --------------------------------------------------
% Aplicação das condições fronteira
% --------------------------------------------------

% Fluxo imposto

for node:1:1:length(n_out)

    if n_out(node,2) = 















% Cria (ou abre se já existente) ficheiro dados.txt no diretorio atual


dados = fopen('dados.txt', 'w');

fprintf(dados, '# - Escoamento_Potencial de velocidade');


% ----------------------------------------------------------------
% Adiciona dados extraídos do fichiero do NX ao ficheiro dados.txt
% ----------------------------------------------------------------

% Escreve as coordenadas dos nós

writematrix('# Coordenadas dos nos', 'dados.txt','WriteMode', 'append');
%fprintf(dados, '# Coordenadas dos nos\n');
numnos=length(n_out);
%fprintf(dados, num2str(numnos));
writematrix(num2str(numnos), 'dados.txt','WriteMode', 'append')
%fprintf(dados, '\n');
writematrix(n_out, 'dados.txt','Delimiter', 'space', 'WriteMode', 'append');

% Escreve a matriz de conectividades

%fprintf(dados, '# Matriz de incidências/conectividades\n');
writematrix('# Matriz de incidências/conectividades','dados.txt','WriteMode', 'append' );
%fprintf(dados, string(length(el_out)));
writematrix(string(length(el_out)), 'dados.txt', 'WriteMode', 'append');
writematrix(el_out,'dados.txt', 'Delimiter', 'space', 'WriteMode', 'append');


% Escreve as propriedades do material

writematrix('# Propriedades do material', 'dados.txt','WriteMode', 'append');
writematrix(numero_materiais, 'dados.txt','WriteMode', 'append');
mat_=cat(2,material,prop_material);
writematrix(mat_, 'dados.txt', 'Delimiter', 'space', 'WriteMode', 'append');

% writematrix(  , 'dados.txt','WriteMode', 'append');


% Escreve as fontes e carregamentos distriubidos

writematrix('# Fontes e carregamentos distribuidos', 'dados.txt','WriteMode', 'append');
writematrix('0', 'dados.txt','WriteMode', 'append');

% Escreve as condições de fronteira esseciais

writematrix('# Condições de fronteira essenciais', 'dados.txt','WriteMode', 'append');


% Escreve as fontes e cargas pontuais

writematrix('# Fontes/cargas pontuais impostas', 'dados.txt','WriteMode', 'append');
writematrix('0', 'dados.txt','WriteMode', 'append');

% Escreve o fluxo imposto na fronteira (condição de fronteira natural)




% Escreve a condição de fronteira mista

writematrix('# Condições de fronteira mistas  - Convecção natural', 'dados.txt','WriteMode', 'append');
writematrix('0', 'dados.txt','WriteMode', 'append');


% FLUXO IMPOSTO NA FRONTEIRA E CONDIÇOES ESSENCIAIS






% Fecha o ficheiro dados.txt

fclose(flux_file);
fclose(dados);








%{


% Extração de informação sobre o fluxo imposto na fronteira

%flux_lines = splitlines(fscanf(flux_file, formatspec));
%flux_raw = splot(flux_lines);
filt_flux = [];

for i=2:1:(length(flux_lines)-1)

    filt_flux = [filt_flux; flux_lines(i,1)];

end

flux_lines = filt_flux;
flux_col = split(flux_lines);

%Inicialização de variáveis

f_el = []; % Número do elemento
f_n1 = []; % Número do nó 1
f_n2 = []; % Número do nó 2
f_n3 = []; % Número do nó 3 (T6)
flux = []; % Valor do fluxo imposto

% Verificar tipo de elemento



if element_type(1) == 6

    for i=1:1:length(flux_col)

        f_el = [f_el; flux_col()];
        f_n1 = [f_n1; flux_col()];
        f_n2 = [f_n2; flux_col()];
        f_n3 = [f_n3; flux_col()];
        flux = [flux; flux_col()];
        
    end
    
    flux_out = cat(f_el, f_n1, f_n2, f_n3, flux);

else

    for i=1:1:length(flux_col)

        f_el = [f_el; flux_col(i,1)];
        f_n1 = [f_n1; flux_col(i,3)];
        f_n2 = [f_n2; flux_col()];
        flux = [flux; flux_col()];

    end

    flux_out = cat(f_el, f_n1, f_n2, flux);

end
%}
