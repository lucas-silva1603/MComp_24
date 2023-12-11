function [x,y, elementos, potencial, fluxo] = import_txt(txt_f)

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

%txt_f = 'dados.txt';
%file = txt_f;
file = string(txt_f);
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
x = nos(:,2)/1000;
y = nos(:,3)/1000;
% -------------------------------


% ----------------------
% Extração dos elementos
% ----------------------


elem_num = str2double(lines(nos_num + 5,1));
elem_raw=[];
last_elem = nos_num + 5 + elem_num;
for i=(nos_num+6):1:last_elem
    
    elem_raw = [elem_raw, lines(i,1)];

end
next = i;

elem_raw = elem_raw';

% Output elementos

% --------------------------------------
elementos = str2double(split(elem_raw));
% --------------------------------------


% ----------------------------
% Extração condições fronteira
% ----------------------------

% Essenciais

p_raw = [];
pstart = last_elem + 8;
pend = str2double(lines(pstart-1)) + pstart - 1 ;

for n=pstart:1:pend

    p_raw = [p_raw; lines(n,1)];

end

% Output potencial imposto
% -----------------------------------
potencial = str2double(split(p_raw));
% -----------------------------------


% Fluxo imposto

fstart = pend + 5;
fend = fstart - 1 + str2double(lines(fstart - 1));
f_raw = [];

for k=fstart:1:fend
    f_raw = [f_raw; lines(k)];
end

% Output fluxo imposto
% -------------------------------
fluxo = str2double(split(f_raw));
% -------------------------------


