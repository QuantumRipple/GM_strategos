///scr_server_seng_game_over(defeat_reason)
buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.game_over);
buffer_write(write_buffer, buffer_u8, argument[0] mod 2 == 0); //if B lost, send true for winner to A
if (argument[0] < 3){ //flag lost
    buffer_write(write_buffer, buffer_u8, 0);
} else if (argument[0] < 5) { //no movable pieces
    buffer_write(write_buffer, buffer_u8, 1);
} else { //TODO: forefiet?
    buffer_write(write_buffer, buffer_u8, 2);
}
for (var i=0; i<10; ++i) {
    for (var j=0; j<8; ++j) {
        if (board[i,j].owner!=2) {
            buffer_write(write_buffer, buffer_u8, board[i,j].type);
            buffer_write(write_buffer, buffer_u8, i);
            buffer_write(write_buffer, buffer_u8, j);
        }
    }
}
buffer_write(write_buffer, buffer_u8, 0); //null terminate the list

network_send_packet(client[0], write_buffer, buffer_tell(write_buffer));

//send to the other player
buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.game_over);
buffer_write(write_buffer, buffer_u8, argument[0] mod 2 == 1); //if A lost, send true for winner to B
if (argument[0] < 3){ //flag lost
    buffer_write(write_buffer, buffer_u8, 0);
} else if (argument[0] < 5) { //no movable pieces
    buffer_write(write_buffer, buffer_u8, 1);
} else { //TODO: forefiet?
    buffer_write(write_buffer, buffer_u8, 2);
}
for (var i=0; i<10; ++i) {
    for (var j=0; j<8; ++j) {
        if (board[i,j].owner!=2) {
            buffer_write(write_buffer, buffer_u8, board[i,j].type);
            buffer_write(write_buffer, buffer_u8, 9-i);
            buffer_write(write_buffer, buffer_u8, 7-j);
        }
    }
}
buffer_write(write_buffer, buffer_u8, 0); //null terminate the list

network_send_packet(client[1], write_buffer, buffer_tell(write_buffer));
