clc
clear
[x,y, elem, potencial, Neumann_Bound, fp, cr] = import_txt('dados.txt');

elem(:,3:end)

Different0 = Neumann_Bound(:, end) ~= 0;

Neumann_Bound = Neumann_Bound(Different0, :);

n = size(Neumann_Bound,1);
