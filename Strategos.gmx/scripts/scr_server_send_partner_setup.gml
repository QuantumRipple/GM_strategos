///scr_server_send_partner_setup(player_index)
buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.partner_setup);
network_send_packet(client[argument[0]], write_buffer, buffer_tell(write_buffer));
