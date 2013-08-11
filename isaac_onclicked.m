function isaac_onclicked(h,~)
    global BLUE;
    global RED;
    
    pt = get(gca, 'CurrentPoint');    
    x = round(pt(1,2));
    y = round(pt(1,1));
    [x, y]

    found = false;
    for n = 1:size(BLUE,1)
        if x == BLUE(n,1) && y == BLUE(n,2)
            disp('BLUE');
            BLUE(n,:)
            BLUE(n,6) = 1-BLUE(n,6);
            found = true;
        end
    end
    for n = 1:size(RED,1)         
        if x == RED(n,1) && y == RED(n,2)
            disp('RED ');
            RED(n,:)
            RED(n,6) = 1-RED(n,6);
            found = true;
        end        
    end
    
    if ~found
        disp('Not found');
    end
end