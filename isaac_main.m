function isaac_main()
    global BLUE;
    global RED;
    global battle_size;
    global flag_pos;
    global should_stop;
    
    isaac_params2();    
    isaac_init();
    
    handle = figure();
    set(handle, 'WindowButtonDownFcn', @isaac_onclicked);
    xlim([0, battle_size+1]);
    ylim([0, battle_size+1]);

    colormap([ 
        0.1 0.1 0.1;    % 0 blackground 
        0.0 0.5 1.0;    % 1 blue healthy
        0.0 0   1.0;    % 2 blue injured
        0.0 0   0.3;    % 3 blue killed 
        1.0 0.3 0.0;    % 4 red  healthy
        1.0 0   0.0;    % 5 red  injured
        0.3 0   0.0;    % 6 red  killed
        1.0 1   1.0;    % 7 flag color
    ]);
    hold on;

    should_stop = false;
    while (~should_stop)
        if (rand() < 0.5)
            [RED, BLUE] = isaac_shoot(1);
            [BLUE, RED] = isaac_shoot(2);
        else
            [BLUE, RED] = isaac_shoot(2);                        
            [RED, BLUE] = isaac_shoot(1);
        end
        
        battle_map = zeros(battle_size, battle_size);
        battle_map(sub2ind([battle_size,battle_size],BLUE(:,1), BLUE(:,2)))=1+BLUE(:,4);
        battle_map(sub2ind([battle_size,battle_size],RED (:,1), RED (:,2)))=4+RED (:,4);        

        % cheat colormap by forcing the max value of 7
        battle_map(flag_pos(1,1), flag_pos(1,2)) =7;%flag
        battle_map(flag_pos(2,1), flag_pos(2,2)) =7;%flag
        pcolor(battle_map);
        drawnow
        
        if (rand() < 0.5)
            BLUE = isaac_move(1);
            RED  = isaac_move(2);
        else
            RED  = isaac_move(2);            
            BLUE = isaac_move(1);            
        end

                
    end
    
    hold off;    
    close(handle);
end 


