clear
clc all

% Importa ficheiro de dados do NX

% Lê dados do ficheiro do NX e extrai informção, guardando em listas para
% analise posterior

numero_nos = [1;1];
x_nos = [2;2];
y_nos =  [3;3];

nos = [numero_nos x_nos y_nos];

for i = 1:num_nos
    nos(end+1,1) = i;
    nos(end,2) = x_no(i);
    nos(end, 3) = y_no(i)
end
    
    
   





% 3 colunas, #linhas linhas



% Cria (ou abre se já existente) ficheiro dados.txt no diretorio atual

dados = fopen('dados.txt', 'w');

fprintf(dados, '# - Escoamento_Potencial de velocidade\n');

% Adiciona dados extraídos do fichiero do NX ao ficheiro dados.txt

% Adiciona coordenadas dos nós

fprintf(dados, '#Coordenadas dos nos\n');
[l,c] = size(nos_array);
fprinft(dados, l)






% Fecha o ficheiro dados.txt

fclose(dados);
