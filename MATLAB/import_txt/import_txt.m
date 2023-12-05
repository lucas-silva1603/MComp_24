%function [nodes, elements] = importfile(txt_f)

% -----------
% Import File
% -----------

% -----------------------------------------------------------------------
% Esta função importa os dados do ficheiro de dados fornecido (no formato
% .txt e devolve informações sobre os nos, elementos, codiçóes fronteira,
% propriedades do material, e carregamentos aplicados
% ----------------------------------------------------------------------

% -------------
% Inicialização
% -------------

% Abre o ficheiro de dados para leitura

txt_f = 'dados.txt';
file = txt_f;
%file = string(txt_f);
data = fopen(file,"r");
formatspec = '%c';'%d"';

% Sepra o ficheiro em linhas para processamento da informação

lines = splitlines(fscanf(data, formatspec));

% ----------------
% Extração dos nós
% ----------------

nos_num = str2double(lines(3,1));
nos_raw=[];

for i=4:1:(nos_num + 3)

    nos_raw=[nos_raw, lines(i)];

end

nos_raw = nos_raw';

% Output nós

% -------------------------------
nos = str2double(split(nos_raw));
no_number = nos(:,1);
x = nos(:,2);
y = nos(:,3);
% -------------------------------


% ----------------------
% Extração dos elementos
% ----------------------


elem_num = str2double(lines(nos_num + 5,1));
elem_raw=[];
last_elem = nos_num + 5 + elem_num;
for i=61:1:last_elem
    
    elem_raw = [elem_raw, lines(i,1)];

end

elem_raw = elem_raw';

% Output elementos

% --------------------------------------
elementos = str2double(split(elem_raw));
% --------------------------------------





%end

