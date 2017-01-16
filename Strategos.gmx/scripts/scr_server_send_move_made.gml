//scr_server_send_move_made(player, xstart, ystart, xend, yend, attacker, defender, spot)
if (argument[0] == 0) var opponent = 1; else var opponent = 0;

buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.move_made);
buffer_write(write_buffer, buffer_u8, argument[1]);//xstart
buffer_write(write_buffer, buffer_u8, argument[2]);//ystart
buffer_write(write_buffer, buffer_u8, argument[3]);//xend
buffer_write(write_buffer, buffer_u8, argument[4]);//yend
buffer_write(write_buffer, buffer_u8, argument[5]);//attacker
buffer_write(write_buffer, buffer_u8, argument[6]);//defender
buffer_write(write_buffer, buffer_u8, argument[7]);//spot
buffer_write(write_buffer, buffer_u8, false);
network_send_packet(client[argument[0]], write_buffer, buffer_tell(write_buffer));

buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.move_made);
buffer_write(write_buffer, buffer_u8, argument[1]);//xstart
buffer_write(write_buffer, buffer_u8, argument[2]);//ystart
buffer_write(write_buffer, buffer_u8, argument[3]);//xend
buffer_write(write_buffer, buffer_u8, argument[4]);//yend
buffer_write(write_buffer, buffer_u8, argument[5]);//attacker
buffer_write(write_buffer, buffer_u8, argument[6]);//defender
buffer_write(write_buffer, buffer_u8, argument[7]);//spot
buffer_write(write_buffer, buffer_u8, true);
network_send_packet(client[opponent], write_buffer, buffer_tell(write_buffer));
