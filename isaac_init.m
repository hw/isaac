function isaac_init()
    global BLUE;
    global RED;
    global force_size;
    global battle_size;
    
    % 1:X, 2:Y, 3:type, 4:state, 5:time till reconstitution, 6:debug flag
    % state: (0=healthy, 1=injured, 2=dead)

    BLUE = zeros(force_size(1), 6); 
    RED  = zeros(force_size(2), 6);
  
    % distribute entities to two corners of the battlespace
    BLUE(:,1:2) = mod([randperm(size(BLUE,1), size(BLUE,1))',  ... 
                       randperm(size(BLUE,1), size(BLUE,1))'], ... 
                       battle_size/2)+1;
    RED (:,1:2) = mod([randperm(size(RED,1), size(RED,1))',  ... 
                       randperm(size(RED,1), size(RED,1))'], ... 
                       battle_size/2)+battle_size/2+1;
                   
%    BLUE(:,1:2) = randi(battle_size/2, size(BLUE,1),2);
%    RED (:,1:2) = randi(battle_size/2, size(RED,1),2)+battle_size/2;    
end