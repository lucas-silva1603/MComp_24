clc
clear
[x,y, elem, potencial, fluxo] = import_txt('dados.txt');

elem = elem(:,3:6)
elem(:,end+1) = 0;
