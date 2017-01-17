///scr_show_move(x_start, y_start, x_end, y_end, attacker_type if revealed , defender_type if revealed, spot_type)

show_debug_message("showing move: "+string(argument[0])+", "+string(argument[1])+", "+string(argument[2])+", "+string(argument[3])+", "+string(argument[4])+", "+string(argument[5])+", "+string(argument[6]) );

if (board[argument[0], argument[1]].owner==0){ //this was a move we made, so we've had time to see the current revealed pieces
    with(obj_base_tile) { //about to show a new move, unset all "just" revealed variables
        just_revealed = false;
    }
}

var inst = noone;

if (argument[5] != 0) { //defender is revealed
    if argument[6] != 0 { //spot, so x_end/y_end doesn't indicate revealed piece
        if (board[argument[0], argument[1]].owner==0) {//we own, so the next spot up
            inst = board[argument[2],argument[3]-1];
        } else {
            inst = board[argument[2],argument[3]+1]
        }
    } else{
        inst = board[argument[2],argument[3]];
    }
    with (inst) { //defender
        type = argument[5];
        revealed = true;
        just_revealed = true;
        if ((argument[6] == 0 && scr_battle_eval(argument[4], argument[5])!=1) || argument[6]==argument[5]) { //successful spot or combat that defender lost
            state = 3; //successful spot means defender is dead
            if (owner==0) { //we were defending, send it to the other side's board
                other.friendly_tiles[type] -= 1;
                xstart = scr_type_pos_x(type,other.friendly_tiles[type]);
                ystart = scr_type_pos_y(type,other.friendly_tiles[type],1);
            } else { //enemy defender
                other.enemy_tiles[type] -= 1;
                xstart = scr_type_pos_x(type,other.enemy_tiles[type]);
                ystart = scr_type_pos_y(type,other.enemy_tiles[type],0);
            }
            
            other.board[grid_x,grid_y]=noone; //will be overwritten if attacker moves into our spot
            death_waiting = true; //move delay
            other.move_animation_waiting += 1;
            slide_decr=true;
        } 
    }
}

with(board[argument[0], argument[1]]) { //mover/attacker
    if (argument[4] != 0) { //attacker is revealed
        type = argument[4];
        revealed = true;
        just_revealed = true;
    };

    grid_x = argument[2];
    grid_y = argument[3];
    if (argument[0]!=argument[2] || argument[1]!=argument[3]) moved = true;
    other.board[argument[0],argument[1]]=noone; //important that this is first in case we didn't move
    if (argument[5]==0 || argument[6]!=0) { //move into a clear space or spot (which is also a move into a clear space if there was a move)
        other.board[argument[2],argument[3]]=self;
    } else { //combat
        if (scr_battle_eval(argument[4], argument[5])!=0) { //defender won or tie
            state=3;
            if (owner==0) { //we were attacking, send it to the other side's board
                other.friendly_tiles[type] -= 1;
                xstart = scr_type_pos_x(type,other.friendly_tiles[type]);
                ystart = scr_type_pos_y(type,other.friendly_tiles[type],1);
            } else { //enemy attacker
                other.enemy_tiles[type] -= 1;
                xstart = scr_type_pos_x(type,other.enemy_tiles[type]);
                ystart = scr_type_pos_y(type,other.enemy_tiles[type],0);
            }
            death_waiting=true; //die after our slide
            other.move_animation_waiting += 1;
        } else { //we lived and move into the spot
            other.board[argument[2],argument[3]]=self;
        }
    }
    slide_decr=true;
    other.move_animation_waiting += 1;
    scr_slide(params.board_offset_x + grid_x*params.board_grid_size, params.board_offset_y + grid_y*params.board_grid_size, -10, 10, 2, 90); //slowly slide moved piece into position, rest of animation handled in step event upon sliding end

    slide_last_animation_waiting = other.move_animation_waiting;
}
if (inst != noone) inst.slide_last_animation_waiting = move_animation_waiting;
