function elementos = selecionar_elementos(tri, nos)
    elementos = [];
    for i = 1:length(nos)
        for j = 1:length(nos)
            if i ~= j
                for k = 1:length(tri)
                    if any(tri(k,:) == nos(i)) && any(tri(k,:) == nos(j))
                        elementos = [elementos; k];
                    end
                end
            end
        end
    end
    elementos = sort(elementos);
    elementos = unique(elementos(:).');
end