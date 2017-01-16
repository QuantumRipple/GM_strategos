///scr_show_move(x_start, y_start, x_end, y_end, attacker_type if revealed , defender_type if revealed, spot_type)

show_debug_message("showing move: "+string(argument[0])+", "+string(argument[1])+", "+string(argument[2])+", "+string(argument[3])+", "+string(argument[4])+", "+string(argument[5])+", "+string(argument[6]) );

if (argument[5] != 0) { //enemy is revealed
    if argument[6] != 0 { //spot, so x_end/y_end doesn't indicate revealed piece
        if (board[argument[0], argument[1]].owner) {//we own, so the next spot up
            var inst = board[argument[2],argument[3]-1];
        } else {
            var inst = board[argument[2],argument[3]+1]
        }
    } else{
        var inst = board[argument[2],argument[3]];
    }
    with (inst) { //defender
        type = argument[5];
        revealed = true;
        just_revealed = true;    
    }
}

with(board[argument[0], argument[1]]) { //mover/attacker
    if (argument[4] != 0) {
        type = argument[4];
        revealed = true;
        just_revealed = true;
    };
    if (argument[0]!=argument[2] || argument[1]!=argument[3]) moved = true;
    scr_slide(params.board_offset_x + argument[2]*params.board_grid_size, params.board_offset_y + argument[3]*params.board_grid_size, -10, 10, 5, 50); //slowly slide moved piece into position, rest of animation handled in step event upon sliding end
}
move_animation_waiting = 1;
spot_waiting = argument[6];
