var buf = argument[0];
var socket = argument[1];
var player = argument[2];
var msgId = buffer_read(buf, buffer_u8);

if (player == 0) var opponent = 1; else var opponent = 0;

switch (msgId) {
    case message_type.submit_board:
        if (ready[player]) {
            //TODO: error
            break;
        }
        if (player==0) {
            for (var i=0; i < 10; ++i) {
                for (var j=7; j >= 5; --j) {
                    var type = buffer_read(buf, buffer_u8);
                    board[i,j].owner = player;
                    board[i,j].type = type;
                    if captured_a[type] > 0 {
                        captured_a[type] -= 1;
                        captured_a[tile_type.blank] += 1;
                    }
                }
            }
            if captured_a[tile_type.blank] != 30 {
                //TODO: error
                captured_a = scr_type_count_array(); //reset piece array
                break;
            }
        } else {
            for (var i=9; i >= 0; --i) {
                for (var j=0; j < 3; ++j) {
                    var type = buffer_read(buf, buffer_u8);
                    board[i,j].owner = player;
                    board[i,j].type = type;
                    if captured_b[type] > 0 {
                        captured_b[type] -= 1;
                        captured_b[tile_type.blank] += 1;
                    }
                }
            }
            if captured_b[tile_type.blank] != 30 {
                //TODO: error
                captured_b = scr_type_count_array(); //reset piece array
                break;
            }
        }
        ready[player] = true;
        if (client[opponent] != noone) { //wouldn't be unusual to lock in before opponent connects
            scr_server_send_partner_setup(opponent);
        }
        if (ready[0] && ready[1]) { //TODO: deal with the error case where partner DC'd after setting up
            scr_server_send_game_start(1); //tell player 1 first since he isn't allowed to make the next move
            scr_server_send_game_start(0);
        }
        break;
    case message_type.submit_move:
        if (turn != player) {
            //TODO: error
            break;
        };
        var tempx = buffer_read(buf, buffer_u8);
        var tempy = buffer_read(buf, buffer_u8);
        var destx = buffer_read(buf, buffer_u8);
        var desty = buffer_read(buf, buffer_u8);
        var spot = buffer_read(buf, buffer_u8);
        
        //TODO: bounds checking
        
        var type = board[tempx,tempy].type;
        var def = board[destx,desty].type;
        
        if (board[tempx,tempy].owner != player || 
            !(type==tile_type.spy || type==tile_type.spotter_1 || type==tile_type.scout_2 || type==tile_type.miner_3 || type==tile_type.sergeant_4 || type==tile_type. lieutenant_5 ||
              type==tile_type.captain_6 || type==tile_type.major_7 || type==tile_type.colonel_8 || type==tile_type.general_9 || type==tile_type.marshal_10) || 
            !(board[destx,desty].owner=opponent || def=tile_type.blank || (spot != 0 && tempx=destx && tempy=desty && type==tile_type.spotter_1))) {
            //TODO: error
            break;
        } else if (type == tile_type.scout_2) {
            //TODO: verify intermediate spaces for long scout moves
        } else if (type == tile_type.spotter_1) {
            //TODO: verify legal location for a spot
        }
        
        //comitted from here on out
        turn = opponent;
        if (def == tile_type.blank || (tempx==destx && tempy==desty)) { //not a regular combat
            board[tempx,tempy].moved = tempx!=destx || tempy!=desty;
        
            if (player==0) var spdef = board[destx, desty-1]; else var spdef = board[destx, desty+1];
            def = spdef.type;
            var temp_loc = board[destx,desty]; //swap works okay even when spotter isn't moving
            board[destx,desty] = board[tempx,tempy];
            board[tempx,tempy] = temp_loc; //swap with the empty space is easier than moving all the values
            if (spot != 0) { //spotter (with optional move)
                board[destx,desty].revealed = true; //post swap
                if (spot == def) { //correct spotting, kill the spotted piece
                    if player==0 {
                        captured_b[def] += 1;
                    } else {
                        captured_a[def] += 1;
                    }
                    spdef.owner = 2;
                    spdef.type = tile_type.blank;
                    spdef.revealed = false;
                    spdef.moved = false;
                } else { //still reveals target
                    spdef.revealed = true;
                }
                scr_server_send_move_made(player,tempx,tempy,destx,desty,type,def,spot);
            } else { //just a plain move
                if (max(abs(tempx-destx),abs(tempy-desty)) > 1) { //scout moved more than 1 reveals it
                    board[destx,desty].revealed = true;
                    scr_server_send_move_made(player,tempx,tempy,destx,desty,type,0,0);
                } else {
                    scr_server_send_move_made(player,tempx,tempy,destx,desty,0,0,0);
                }
            }
        } else { //combat
            switch(scr_battle_eval(type,def)) {
                case 0: //attacker won
                    if player==0 {
                        captured_b[def] += 1;
                    } else {
                        captured_a[def] += 1;
                    }
                    //move attacker into defender spot
                    board[destx,desty] = board[tempx,tempy];
                    board[destx,desty].revealed = true;
                    board[destx,desty].moved = true;
                    //clear attacker's old spot
                    board[tempx,tempy].owner = 2;
                    board[tempx,tempy].type = tile_type.blank;
                    board[tempx,tempy].revealed = false;
                    board[tempx,tempy].moved = false;
                    break;
                case 1: //defender won
                    if player==0 {
                        captured_a[type] += 1;
                    } else {
                        captured_b[type] += 1;
                    }
                    //reveal defender
                    board[destx,desty].revealed = true;
                    //clear attacker's old spot
                    board[tempx,tempy].owner = 2;
                    board[tempx,tempy].type = tile_type.blank;
                    board[tempx,tempy].revealed = false;
                    board[tempx,tempy].moved = false;
                    break;
                case 2: //tie
                    captured_a[type] += 1; //ties are caused by type==def, so no need to switch
                    captured_b[type] += 1;
                    //clear defender's old spot
                    board[destx,desty].owner = 2;
                    board[destx,desty].type = tile_type.blank;
                    board[destx,desty].revealed = false;
                    board[destx,desty].moved = false;
                    //clear attacker's old spot
                    board[tempx,tempy].owner = 2;
                    board[tempx,tempy].type = tile_type.blank;
                    board[tempx,tempy].revealed = false;
                    board[tempx,tempy].moved = false;
                    break;
            }
           scr_server_send_move_made(player,tempx,tempy,destx,desty,type,def,0);
        }
        break;
    case message_type.request_refresh:
        scr_server_send_refresh(player);
        break;
}
