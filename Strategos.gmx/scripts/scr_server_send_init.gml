///scr_server_send_init(player_index)
if (argument[0] == 0) var opponent = 1;
else var opponent = 0;

buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.init);
buffer_write(write_buffer, buffer_u8, argument[0]);
if (client[opponent]==noone) {
    buffer_write(write_buffer, buffer_u8, 1); //no partner
} else if (ready[opponent]==false) {
    buffer_write(write_buffer, buffer_u8, 2); //partner not ready
} else {
    buffer_write(write_buffer, buffer_u8, 3); //partner ready
}

network_send_packet(client[argument[0]], write_buffer, buffer_tell(write_buffer));
