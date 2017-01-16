///scr_server_send_refresh(player_index)
if (argument[0] == 0) var opponent = 1;
else var opponent = 0;

buffer_seek(write_buffer, buffer_seek_start, 0);

buffer_write(write_buffer, buffer_u8, message_type.refresh_data);
buffer_write(write_buffer, buffer_u8, argument[0]); //player
if (client[opponent]==noone) { //state
    buffer_write(write_buffer, buffer_u8, 1); //no partner
} else if (ready[opponent]==false) {
    buffer_write(write_buffer, buffer_u8, 2); //partner not ready
} else if (state == 1) {
    buffer_write(write_buffer, buffer_u8, 4); //in play
} else {
    buffer_write(write_buffer, buffer_u8, 3); //this should never be true...
}
buffer_write(write_buffer, buffer_u8, argument[0]==turn || ready[argument[0]]==false); //if it is the target's turn
for (var i = 0; i < 10; ++i) {
    for (var j = 0; j < 8; ++j) {
        if (board[i,j].owner < 2) {
            buffer_write(write_buffer, buffer_u8, board[i,j].owner == argument[0]); //ownwer is target?
            buffer_write(write_buffer, buffer_u8, 2); //if it is on the board, tile state is 2 (in play)
            if (board[i,j].owner == argument[0] || board[i,j].revealed) { //target owns this piece or has seen it's value
                buffer_write(write_buffer, buffer_u8, board[i,j].type);
            } else {
                buffer_write(write_buffer, buffer_u8, tile_type.blank); //hide the type from this client
            }
            buffer_write(write_buffer, buffer_u8, board[i,j].revealed);
            buffer_write(write_buffer, buffer_u8, board[i,j].moved);
            buffer_write(write_buffer, buffer_u8, i);
            buffer_write(write_buffer, buffer_u8, j);
        }
    }
}
if (argument[0]==0 || ready[0]==true){ //to avoid sending opponents unplaced pieces
    for (var i = tile_type.flag; i <= tile_type.bomb; ++i) { //target's captured pieces
        for (var j = 0; j < captured_a[i]; ++j) { //doesn't activate at all for uncaptured pieces
            buffer_write(write_buffer, buffer_u8, argument[0]==0); //ownwer is target?
            if (ready[0]==false) {
                buffer_write(write_buffer, buffer_u8, 0); //not intended use case (may be bugs), but target hasn't submitted yet, these are unset pieces
            } else {
                buffer_write(write_buffer, buffer_u8, 3); //this piece is dead
            }
            buffer_write(write_buffer, buffer_u8, i); //piece type is always known for off-board pieces
            buffer_write(write_buffer, buffer_u8, true); //revealed, all dead pieces are revealed
            buffer_write(write_buffer, buffer_u8, false); //moved data isn't preserved past death
            buffer_write(write_buffer, buffer_u8, 0); //gridx/gridy don't matter
            buffer_write(write_buffer, buffer_u8, 0);
        }
    }
}
if (argument[0]==1 || ready[1]==true){ //to avoid sending opponents unplaced pieces
    for (var i = tile_type.flag; i <= tile_type.bomb; ++i) { //target's captured pieces
        for (var j = 0; j < captured_b[i]; ++j) { //doesn't activate at all for uncaptured pieces
            buffer_write(write_buffer, buffer_u8, argument[0]==1); //ownwer is target?
            if (ready[1]==false) {
                buffer_write(write_buffer, buffer_u8, 0); //not intended use case (may be bugs), but target hasn't submitted yet, these are unset pieces
            } else {
                buffer_write(write_buffer, buffer_u8, 3); //this piece is dead
            }
            buffer_write(write_buffer, buffer_u8, i); //piece type is always known for off-board pieces
            buffer_write(write_buffer, buffer_u8, true); //revealed, all dead pieces are revealed
            buffer_write(write_buffer, buffer_u8, false); //moved data isn't preserved past death
            buffer_write(write_buffer, buffer_u8, 0); //gridx/gridy don't matter
            buffer_write(write_buffer, buffer_u8, 0);
        }
    }
}
buffer_write(write_buffer, buffer_u8, 2); //terminate the piece list

network_send_packet(client[argument[0]], write_buffer, buffer_tell(write_buffer));
