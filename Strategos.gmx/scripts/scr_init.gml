global.player = 1; //0=red, 1= blue
global.state = 0;
global.turn = false;
global.track_enemy_revealed = false;
global.track_enemy_moved = false;
global.track_my_moved = false;
global.track_my_revealed = false;

enum message_type {
    submit_board,
    submit_move,
    request_refresh,
    error_illegal_board,
    error_unexpected_message,
    error_illegal_move,
    refresh_data,
    message,
    partner_setup,
    partner_connected,
    partner_disconnected,
    move_made,
    init,
    game_over,
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
    y_size = 72,
    default_min_slide = 5, //slide function defaults
    default_max_slide = 50,
    default_slide_time = 5,
    default_slide_depth = -10,
    buffer_size = 1024, //network buffer sizes
    submit_x = 400, //submit button location
    submit_y = 300,
    spot_x = 400,
    spot_y = 300,
    nospot_x = 550,
    nospot_y = 300,
    spot_sel_x = 100,
    spot_sel_y = 100,
    spot_sel_grid_size = 50
}
