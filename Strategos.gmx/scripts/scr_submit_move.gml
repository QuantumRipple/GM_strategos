//scr_submit_move(grid_x, grid_y, new_grid_x, new_grid_y, spot_type) spot_type is optional
global.turn = false;
with (obj_client) { //should only be 1
    buffer_seek(write_buffer, buffer_seek_start, 0);
    buffer_write(write_buffer, buffer_u8, message_type.submit_move);
    buffer_write(write_buffer, buffer_u8, argument[0]);
    buffer_write(write_buffer, buffer_u8, argument[1]);
    buffer_write(write_buffer, buffer_u8, argument[2]);
    buffer_write(write_buffer, buffer_u8, argument[3]);
    if (argument_count > 4) buffer_write(write_buffer, buffer_u8, argument[4]);
    else buffer_write(write_buffer, buffer_u8, 0);
    
    network_send_packet(host_socket, write_buffer, buffer_tell(write_buffer));
}
