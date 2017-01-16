///scr_show_move(x_start, y_start, x_end, y_end, attacker_type if revealed , defender_type if revealed, spot_type)
if (argument[5] != 0) {
    with (board[argument[2],argument[3]]) { //defender
        type = argument[5];
        revealed = true;
        just_revealed = true;    
    };
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
