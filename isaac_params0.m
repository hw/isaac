function isaac_params
    global battle_size;

    global BLUE;
    global RED;

    global BLUE_weights;
    global RED_weights;
    global advance_num;  
    global cluster_num;
    global combat_num;    
    global min_flag_dist;
    
    global force_size;    
    global flag_pos;
    
    global max_targets;
    global hit_prob;
    
    global fract_flag;
    global fract_prob;

    global recon_flag;
    global recon_time;
    
    global comms;
    global sensor;
    global fire;
    global threshold;    
    global movement;
    global use_meta_personality;    

    % how many BLUE and RED
    force_size  = [90, 90];         % trial 1
%    force_size  = [50, 100];        % trial 2

    % whether to use meta-personalities
    use_meta_personality = 1;       

    
    % friendies, enemies, inj friendies, inj enemies, own flag, enemy flag
    % penalizes move that are further away from the above
    BLUE_weights = [ 
        1/15, 4/15, 1/15, 4/15, 0, 1/3;
%        0, 50/100, 0, 50/100, 0, 10/100;      % trial 1
%        0, 50/100, 0, 50/100, 0, 10/100;      % trial 2
    ];
    
    RED_randomize = false;
    RED_weights = [ 
        0, 4/15, 1/15, 4/15, 1/3, 0/3;
%        -50/100, -50/100, -50/100, -50/100, -50/100, 0/100; % trial 1
%        0, 50/100, 0, 50/100, 0, 10/100;                     % trial 2
    ];

    if RED_randomize 
        rand_weights = rand(1,6);
        rand_weights(5) = 0;
        total_w = sum(rand_weights);
        RED_weights = rand_weights / total_w
    end
    
    battle_size = 80;
    movement    = [1, 1];
    threshold   = [2, 2];
    fire        = [3, 3];
    sensor      = [5, 5];
    comms       = [5, 5];   % comms not implemented
    
    max_targets = [3, 3];
    hit_prob    = [0.025, 0.025];
    
    fract_flag  = [1, 1];
    fract_prob  = [0.1, 0.1];
    
    recon_flag  = [1, 1];
    recon_time  = [10, 10];
    
    flag_pos    = [ 1, 1 ; battle_size, battle_size];

    advance_num = [  0  ;  1 ];  
    cluster_num = [  0  ;  2 ];
    combat_num  = [  3  ;  0 ]; 

    % distance away from flag
    min_flag_dist = [ 20, 20 ];
    
end