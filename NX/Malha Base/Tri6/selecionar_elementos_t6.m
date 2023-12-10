function elementos = selecionar_elementos_t6(tri, nos)
    elementos = [];
    for i = 1:length(nos)
        for j = 1:length(nos)
            for l = 1:length(nos)
                if i ~= j && i~=l && j~=l
                    for k = 1:length(tri)
                        if (any(tri(k,:) == nos(i))) && (any(tri(k,:) == nos(j) )&& (any(tri(k,:) == nos(l))))
                        elementos = [elementos; k];
                        end
                    end
                end
            end
        end
    end
    elementos = sort(elementos);
    elementos = unique(elementos(:).');
end