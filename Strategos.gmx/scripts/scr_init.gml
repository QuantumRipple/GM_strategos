global.ip = "127.0.0.1";
global.port = 5432;
global.self_host = true;
global.host = true;

global.player = 1; //0=red, 1= blue
global.state = 0;
global.turn = false;
global.track_enemy_revealed = true;
global.track_enemy_moved = true;
global.track_my_moved = true;
global.track_my_revealed = true;

enum message_type {
    submit_board,
    submit_move,
    request_refresh,
    error_illegal_board, //TODO
    error_unexpected_message, //TODO
    error_illegal_move, //TODO
    refresh_data,
    message, //TODO
    partner_setup,
    partner_connected,
    partner_disconnected, //TODO
    move_made,
    init,
    game_over, //TODO
    game_start
}

enum tile_type {
    blank = 0,
    flag = 1,
    spy = 2,
    spotter_1 = 3,
    scout_2 = 4,
    miner_3 = 5,
    sergeant_4 = 6,
    lieutenant_5 = 7,
    captain_6 = 8,
    major_7 = 9,
    colonel_8 = 10,
    general_9 = 11,
    marshal_10 = 12,
    bomb = 13,
    block = 14,
}

enum params {
    board_offset_x = 193, //board background image location
    board_offset_y = 159,
    board_grid_size = 64,
    x_start = 13, //off-board setup positions
    x_size = 72,
    y_start = 700,
    y_size = 70,
    default_min_slide = 5, //slide function defaults
    default_max_slide = 50,
    default_slide_time = 5,
    default_slide_depth = -10,
    buffer_size = 1024, //network buffer sizes
    submit_x = 437, //submit button location
    submit_y = 80,
    random_x = 437,
    random_y = 15,
    spot_x = 337,
    spot_y = 15,
    nospot_x = 537,
    nospot_y = 15,
    spot_sel_x = 187,
    spot_sel_y = 15,
    spot_sel_grid_size = 50
}
