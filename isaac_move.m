function own = isaac_move(force)
    global BLUE;
    global RED;
    global BLUE_weights;
    global RED_weights;
    global advance_num;  
    global cluster_num;
    global combat_num;    
    global min_flag_dist;
    
    global battle_size;
    global flag_pos;
    global sensor;
    global threshold;    
    global movement;
    global use_meta_personality;
    
    if (force == 1)
        own = BLUE;
        enemy = RED;
        weights = BLUE_weights;
    else
        own = RED;
        enemy = BLUE;
        weights = RED_weights;
    end

    range = movement(force);
    sense_range = sensor(force);
    threshold_range = threshold(force);
%     if sense_range > threshold_range 
%         sense_range = threshold_range;
%     end
    
    scale_factor = 1/(1.414*sense_range);
    
    seq = randperm(size(own,1));
    for m = 1:size(own,1)
        n = seq(m);
        state = own(n,4);
        if state == 2
            continue; % dead
        end
        
        x = own(n,1);
        y = own(n,2);
        t = own(n,3);
        w = weights(t+1,:);
        
        dist_own_flag0    = sqrt(sum(([x, y] - flag_pos(force,:)).^2));
        dist_enemy_flag0  = sqrt(sum(([x, y] - flag_pos(3-force,:)).^2));
        [dist_to_friendies, neighbours] = isaac_distance_to(n, x, y, 1, 0, own);

        if dist_own_flag0 < min_flag_dist
            w(5) = -w(5);
        end
        if size(neighbours,1) > 0 && min(sqrt(sum(dist_to_friendies'.^2))) < 0.5
            w(1) = -w(1);   % spread out
        end
        
        current_factors   = [];  % for debugging
        lowest_factors    = [];  % for debugging
        lowest_penality  = 1e99;
        next_move = [];
      
        for x_next = x-range : x+range
            if x_next < 1 || x_next > battle_size
                continue;
            end                    
            for y_next = y-range: y+range;
                if y_next < 1 || y_next > battle_size
                    continue;
                end
                
                % check if already occupied
                is_occupied = false;
                for p = 1:size(own,1)
                    if own(p,1) == x_next && own(p,2) == y_next && p ~=n
                        is_occupied = true;
                        break;
                    end
                end
                if ~is_occupied 
                    for p = 1:size(enemy,1)
                        if enemy(p,1) == x_next && enemy(p,2) == y_next 
                            is_occupied = true;
                            break;
                        end
                    end
                end
                
                if is_occupied 
                    % can't move to this grid, so skip the computation
                    continue;
                end
                
                nearby_enemies       = isaac_distance_to(0, x_next, y_next, sense_range, 0, enemy);
                nearby_friendies     = isaac_distance_to(n, x_next, y_next, sense_range, 0, own);
                nearby_inj_enemies   = isaac_distance_to(0, x_next, y_next, sense_range, 1, enemy);
                nearby_inj_friendies = isaac_distance_to(n, x_next, y_next, sense_range, 1, own);
                
                dist_enemies       = sum(sqrt(sum(nearby_enemies'.^2)));
                dist_friendies     = sum(sqrt(sum(nearby_friendies'.^2)));               
                dist_inj_enemies   = sum(sqrt(sum(nearby_inj_enemies'.^2)));
                dist_inj_friendies = sum(sqrt(sum(nearby_inj_friendies'.^2)));               
                dist_own_flag      = sqrt(sum(([x_next, y_next] - flag_pos(force,:)).^2));
                dist_enemy_flag    = sqrt(sum(([x_next, y_next] - flag_pos(3-force,:)).^2));
                
                % Meta personality
                if use_meta_personality
                    if size(nearby_friendies, 1) < advance_num(force)
                        w(6) = -w(6);
                    end
                    if size(nearby_friendies, 1) > cluster_num(force)
                        w(1) = 0;
                        w(3) = 0;
                    end
                    if size(nearby_friendies, 1) - size(nearby_enemies, 1) < combat_num(force)
                        w(2) = -w(2);
                        w(4) = -w(4);
                    end
                end
                
                
                factors = [scale_factor*dist_friendies; 
                           scale_factor*dist_enemies;                            
                           scale_factor*dist_inj_friendies; 
                           scale_factor*dist_inj_enemies; 
                           dist_own_flag/dist_own_flag0; 
                           dist_enemy_flag/dist_enemy_flag0];
                       
                penality = w * factors;
                if own(n,6) 
                    disp('CANDIDATE:');
                    [x_next, y_next, penality]
                    factors'
                    [nearby_enemies, nearby_friendies]
                end
                
                if x_next == x && y_next == y
                    current_factors = factors;                    
                end
                
                if penality < lowest_penality
                    next_move = [x_next, y_next];
                    lowest_penality = penality;
                    lowest_factors = factors;
                elseif penality == lowest_penality
                    next_move = [next_move; x_next, y_next];    
                end
            end
        end

        if own(n,6) 
            disp('CURRENT:');
            [n, x, y, w * current_factors]
            w
            current_factors'
            lowest_factors'
        end
        
        next_move_index = size(next_move,1);                 
        if (next_move_index > 1) 
            next_move_index  = randi(next_move_index); 
        end

        if next_move_index > 0
            next_x = next_move(next_move_index ,1);
            next_y = next_move(next_move_index ,2); 
            own(n,1) = next_x;
            own(n,2) = next_y;
        else
            no_move=1;
        end            
        
    end
end