//scr_server_send_move_made(player, xstart, ystart, xend, yend, attacker, defender, spot)
if (argument[0] == 0) var opponent = 1; else var opponent = 0;

var xbegin = argument[1];
var ybegin = argument[2];
var xend = argument[3];
var yend = argument[4];

if (argument[0]==1) {
    xbegin = 9-xbegin;
    ybegin = 7-ybegin;
    xend = 9-xend;
    yend = 7-yend;
}

buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.move_made);
buffer_write(write_buffer, buffer_u8, xbegin);//xstart
buffer_write(write_buffer, buffer_u8, ybegin);//ystart
buffer_write(write_buffer, buffer_u8, xend);//xend
buffer_write(write_buffer, buffer_u8, yend);//yend
buffer_write(write_buffer, buffer_u8, argument[5]);//attacker
buffer_write(write_buffer, buffer_u8, argument[6]);//defender
buffer_write(write_buffer, buffer_u8, argument[7]);//spot
buffer_write(write_buffer, buffer_u8, false);
network_send_packet(client[argument[0]], write_buffer, buffer_tell(write_buffer));

xbegin = 9-xbegin;
ybegin = 7-ybegin;
xend = 9-xend;
yend = 7-yend;

buffer_seek(write_buffer, buffer_seek_start, 0);
buffer_write(write_buffer, buffer_u8, message_type.move_made);
buffer_write(write_buffer, buffer_u8, xbegin);//xstart
buffer_write(write_buffer, buffer_u8, ybegin);//ystart
buffer_write(write_buffer, buffer_u8, xend);//xend
buffer_write(write_buffer, buffer_u8, yend);//yend
buffer_write(write_buffer, buffer_u8, argument[5]);//attacker
buffer_write(write_buffer, buffer_u8, argument[6]);//defender
buffer_write(write_buffer, buffer_u8, argument[7]);//spot
buffer_write(write_buffer, buffer_u8, true);
network_send_packet(client[opponent], write_buffer, buffer_tell(write_buffer));
