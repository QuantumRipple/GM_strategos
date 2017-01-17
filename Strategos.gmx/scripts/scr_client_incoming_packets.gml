var buf = argument[0];
var socket = argument[1];
var msgId = buffer_read(buf, buffer_u8);

switch (msgId) {
    case message_type.init: //sets player, says whether partner is already connected, indicates ready to recieve board setup
        global.player = buffer_read(buf, buffer_u8);
        global.state = buffer_read(buf, buffer_u8); //1 = no partner, 2 = partner, 3 = partner ready
        if (global.state != 3) { //fall though to populate enemy pieces if partner is already ready
            break;
        }
    case message_type.partner_setup: //no data, just indicates your partner has finished board setup
        global.state = 3;
        for (var i = 0; i < 10; ++i) {
            for (var j = 0; j <3; ++j) {
                var inst = instance_create(0,0,obj_base_tile);
                inst.owner = 1;
                inst.state = 2;
                inst.grid_x = i;
                inst.grid_y = j;
                board[i,j] = inst;
                inst.x = params.board_offset_x + i*params.board_grid_size; 
                inst.y = params.board_offset_y + j*params.board_grid_size;
            }
        }
        break;
    case message_type.partner_connected: //no data, just indicates another player has connected
        if (global.state < 2) global.state = 2;
        //TODO: if we get this mid-game, its just informational 
        break;
    case message_type.game_start: //data says if it's our turn
        global.state = 4;
        global.turn = buffer_read(buf, buffer_u8);
        break;
    case message_type.move_made: //xstart, ystart, xend, yend, attacker type if revealed (otherwise 0), defender type if revealed (otherwise 0), spot type (0 if no spot), turn
        var a0 = buffer_read(buf, buffer_u8);
        var a1 = buffer_read(buf, buffer_u8);
        var a2 = buffer_read(buf, buffer_u8);
        var a3 = buffer_read(buf, buffer_u8);
        var a4 = buffer_read(buf, buffer_u8);
        var a5 = buffer_read(buf, buffer_u8);
        var a6 = buffer_read(buf, buffer_u8);
        scr_show_move(a0, a1, a2, a3, a4, a5, a6);
        if (move_animation_waiting != 0) turn_waiting = buffer_read(buf, buffer_u8); //it should always hit this case, at least for a single step
        else global.turn = buffer_read(buf, buffer_u8);
        break;
    case message_type.game_over:
        turn_waiting = 0;
        global.turn = false;
        var winner = buffer_read(buf, buffer_u8);
        var reason = buffer_read(buf, buffer_u8); //0 = flag taken, 1 = no movable pieces, 2 = forfiet
        var type = buffer_read(buf, buffer_u8);
        while (type != 0) { //null terminated list of enemy pieces in (type, x, y) format
            var tempx = buffer_read(buf, buffer_u8);
            var tempy = buffer_read(buf, buffer_u8);
            board[tempx, tempy].type = type;
            board[tempx, tempy].state = 3; //dead
            type = buffer_read(buf, buffer_u8);
        }
        break;
    case message_type.refresh_data: //sent upon request or reconnection, contains only data that you would have seen from playing. data is player, game state, turn, then list of pieces
        global.player = buffer_read(buf, buffer_u8);
        global.state = buffer_read(buf, buffer_u8); //1 = no partner, 2 = partner, 3 = partner ready, 4 = in play. An init is sent instead if we haven't submitted a board yet
        global.turn = buffer_read(buf, buffer_u8); //meaningless unless state=4
        
        //break any buttons present, erase state data
        move_animation_waiting = 0;
        spot_waiting = 0;
        turn_waiting = 0;
        placed = 30;
        sel_x = 0;
        sel_y = 0;
        with (obj_button_randomize) instance_destroy();
        with (obj_button_spot) instance_destroy();
        with (obj_button_nospot) instance_destroy();
        with (obj_button_submit) instance_destroy();
        with (obj_spotting_selection) instance_destroy();
        
        for (var i = 0; i < 10; ++i) {
            for (var j = 0; j < 8; ++j) {
                if (board[i,j] != noone && board[i,j].owner != 2) { //erase populated spaces that aren't holding deadspace blocks
                    board[i,j] = noone;
                }
            };
        }
        with (obj_base_tile) { //shoudln't affect deactivated deadspace blocks
            instance_destroy();
        }
        
        
        friendly_tiles = scr_type_count_array();
        enemy_tiles = scr_type_count_array(); //reset the instance variable
        var owner = buffer_read(buf, buffer_u8);
        while (owner != 2) { //format is owner, state, type, revealed, moved, grid_x, grid_y. Type may be 0 if not revealed, grid_x and grid_y may be 0 if dead, terminates with a 2
            var state = buffer_read(buf, buffer_u8);
            var type = buffer_read(buf, buffer_u8);
            var temp_x = 0;
            var temp_y = 0;
            if (type != 0 && state==3) {
                if (owner == 0) {
                    friendly_tiles[type] -= 1;
                    temp_x = scr_type_pos_x(type , friendly_tiles[type]);
                    temp_y = scr_type_pos_y(type , friendly_tiles[type],1);
                } else {
                    enemy_tiles[type] -= 1;
                    temp_x = scr_type_pos_x(type , enemy_tiles[type]);
                    temp_y = scr_type_pos_y(type , enemy_tiles[type],0);
                }
            }
  
            var inst = instance_create(temp_x, temp_y, obj_base_tile);
            inst.owner = owner;
            inst.type = type;
            inst.state = state;
            inst.revealed = buffer_read(buf, buffer_u8);
            inst.moved = buffer_read(buf, buffer_u8);
            
            var temp_grid_x = buffer_read(buf, buffer_u8);
            var temp_grid_y = buffer_read(buf, buffer_u8);
            if state == 2 { //it's on the board so it has to move from the init position into the board position, and be assigned in the array
                inst.x = params.board_offset_x + temp_grid_x*params.board_grid_size; 
                inst.y = params.board_offset_y + temp_grid_y*params.board_grid_size;
                inst.grid_x = temp_grid_x;
                inst.grid_y = temp_grid_y;
                board[temp_grid_x, temp_grid_y] = inst;
            }
            owner = buffer_read(buf, buffer_u8);
        }
        break;
}
