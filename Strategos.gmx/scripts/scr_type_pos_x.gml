///scr_type_pos_x(type, instance) returns the starting x position of a tile. Instance count is 0 based

var x_start = 13;
var x_size = 72;



switch argument[0] {
    case tile_type.flag:
        if      (argument[1]==0) return x_start;
        else                     return -1;
    case tile_type.spy:          
        if      (argument[1]==0) return x_start + x_size;
        else                     return -1;
    case tile_type.spotter_1: 
        if      (argument[1]==0) return x_start + x_size*2;
        else if (argument[1]==1) return x_start + x_size*3;
        else                     return -1;
    case tile_type.scout_2:
        if      (argument[1]==0) return x_start + x_size*4;
        else if (argument[1]==1) return x_start + x_size*5;
        else if (argument[1]==2) return x_start + x_size*6;
        else if (argument[1]==3) return x_start + x_size*7;
        else if (argument[1]==4) return x_start + x_size*8;
        else                     return -1;
    case tile_type.miner_3:
        if      (argument[1]==0) return x_start + x_size*9;
        else if (argument[1]==1) return x_start + x_size*10;
        else if (argument[1]==2) return x_start + x_size*11;
        else if (argument[1]==3) return x_start + x_size*12;
        else if (argument[1]==4) return x_start + x_size*13;
        else                     return -1;
    case tile_type.sergeant_4:
        if      (argument[1]==0) return x_start;
        else if (argument[1]==1) return x_start + x_size;
        else                     return -1;
    case tile_type.lieutenant_5:
        if      (argument[1]==0) return x_start;
        else if (argument[1]==1) return x_start + x_size;
        else                     return -1;
    case tile_type.captain_6:
        if      (argument[1]==0) return x_start;
        else if (argument[1]==1) return x_start + x_size;
        else                     return -1;
    case tile_type.major_7:      
        if      (argument[1]==0) return x_start;
        else                     return -1;
    case tile_type.colonel_8:    
        if      (argument[1]==0) return x_start + x_size;
        else                     return -1;
    case tile_type.general_9:    
        if      (argument[1]==0) return x_start + x_size*12;
        else                     return -1;
    case tile_type.marshal_10:   
        if      (argument[1]==0) return x_start + x_size*13;
        else                     return -1;
    case tile_type.bomb:
        if      (argument[1]==0) return x_start + x_size*12;
        else if (argument[1]==1) return x_start + x_size*13;
        else if (argument[1]==2) return x_start + x_size*12;
        else if (argument[1]==3) return x_start + x_size*13;
        else if (argument[1]==4) return x_start + x_size*12;
        else if (argument[1]==5) return x_start + x_size*13;
        else                     return -1;
}
return -1;
