function [own, enemy] = isaac_shoot(force)
    global BLUE;
    global RED;
    global sensor;
    global fire;
    global max_targets;
    global hit_prob;
    global fract_prob;
    global fract_flag;

    global recon_flag;
    global recon_time;
       
    if (force == 1)
        own   = BLUE;
        enemy = RED;
    else
        own   = RED;
        enemy = BLUE;
    end
    
    % even if fire>sensor, can't shoot until target within shooting range
    % vice verse, can't shoot until target is detected
    effective_dist = min(sensor(force), fire(force));
    use_recon = recon_flag(force);
    
    for n = 1:size(own,1)
        
        state = own(n,4);
        if state == 2            
            continue; % dead
        elseif use_recon && state == 1 
            reconsitution = own(n,5);
            if reconsitution < 1 
                own(n,4) = 0;   % reconsituted - state restored to healthy
            else
                own(n,5) = reconsitution - 1;
            end
            continue;
        end
        
        x = own(n,1);
        y = own(n,2);
        
        % find target
        targets = isaac_within(0, x, y, effective_dist, enemy);
        if size(targets,1) > max_targets(force) 
            % randomly pick max_targets(force) from target list
            num_targets = max_targets(force);
            targets=targets(randperm(size(targets,1), num_targets));
        end

        pss = hit_prob(force);  % Probability Single-shot hit
        if state == 1
            pss = pss * 0.5;    % 1/2 if injured
        end
        
        for j = 1:size(targets,1)
            if rand() < pss
               index = targets(j);
               enemy(index,4) = enemy(index,4)+1;   
               enemy(index,5) = recon_time(3-force);               
            elseif fract_flag(force)
                if (rand() < fract_prob(force))
                    % select one of our own to kill
                    friendies = isaac_within(n, x, y, effective_dist, own);
                    num_friendies = size(friendies,1);
                    if num_friendies > 0
                        index = friendies(randi(num_friendies));
                        own(index, 4) = own(index, 4)+1;
                        own(index, 5) = recon_time(force);
                    end
                end
            end
        end
    end
    
end