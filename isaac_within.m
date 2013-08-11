function result = isaac_within(me, x, y, range, entities)
    result = [];
    for n = 1:size(entities,1)
        if n ~= me && entities(n,4) ~= 2 ... % not dead
        && entities(n,1) >= x-range && entities(n,1) <= x+range ... 
        && entities(n,2) >= y-range && entities(n,2) <= y+range
            result = [result; n];  % return index of entities within range
        end        
    end
end