clc
clear
[x,y, elem, potencial, Neumann_Bound, fp, cr] = import_txt('dados.txt');

elem = elem(:,3:end);
