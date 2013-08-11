function [result, neighbours] = isaac_distance_to(me, x, y, range, state, entities)
    result = [];
    neighbours = [];
    for n = 1:size(entities,1)
        if n ~= me ... %        && entities(n,1) ~= x && entities(n,2) ~= y ...
        && entities(n,1) >= x-range && entities(n,1) <= x+range ...
        && entities(n,2) >= y-range && entities(n,2) <= y+range ...        
            if (entities(n,4) == state) ... % not injured
                result = [result; entities(n,1)-x, entities(n,2)-y];
                neighbours = [neighbours; n];
            end
        end        
    end
end