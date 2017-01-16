///scr_server_send_game_start(player_index)
buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.game_start);
buffer_write(write_buffer, buffer_u8, argument[0]==0); //player 0 always starts
network_send_packet(client[argument[0]], write_buffer, buffer_tell(write_buffer));
