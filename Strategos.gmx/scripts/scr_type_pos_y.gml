///scr_type_pos_y(type, instance) returns the starting y position of a tile. Instance count is 0 based

var y_start = 700;
var y_size = 72;

switch argument[0] {
    case tile_type.flag:         
        if      (argument[1]==0) return y_start;
        else                     return -1;
    case tile_type.spy:          
        if      (argument[1]==0) return y_start;
        else                     return -1;
    case tile_type.spotter_1: 
        if      (argument[1]==0) return y_start;
        else if (argument[1]==1) return y_start;
        else                     return -1;
    case tile_type.scout_2:
        if      (argument[1]==0) return y_start;
        else if (argument[1]==1) return y_start;
        else if (argument[1]==2) return y_start;
        else if (argument[1]==3) return y_start;
        else if (argument[1]==4) return y_start;
        else                     return -1;
    case tile_type.miner_3:
        if      (argument[1]==0) return y_start;
        else if (argument[1]==1) return y_start;
        else if (argument[1]==2) return y_start;
        else if (argument[1]==3) return y_start;
        else if (argument[1]==4) return y_start;
        else                     return -1;
    case tile_type.sergeant_4:
        if      (argument[1]==0) return y_start - y_size;
        else if (argument[1]==1) return y_start - y_size;
        else                     return -1;
    case tile_type.lieutenant_5:
        if      (argument[1]==0) return y_start - y_size*2;
        else if (argument[1]==1) return y_start - y_size*2;
        else                     return -1;
    case tile_type.captain_6:
        if      (argument[1]==0) return y_start - y_size*3;
        else if (argument[1]==1) return y_start - y_size*3;
        else                     return -1;
    case tile_type.major_7:      
        if      (argument[1]==0) return y_start - y_size*4;
        else                     return -1;
    case tile_type.colonel_8:    
        if      (argument[1]==0) return y_start - y_size*4;
        else                     return -1;
    case tile_type.general_9:    
        if      (argument[1]==0) return y_start - y_size;
        else                     return -1;
    case tile_type.marshal_10:   
        if      (argument[1]==0) return y_start - y_size;
        else                     return -1;
    case tile_type.bomb:
        if      (argument[1]==0) return y_start - y_size*2;
        else if (argument[1]==1) return y_start - y_size*2;
        else if (argument[1]==2) return y_start - y_size*3;
        else if (argument[1]==3) return y_start - y_size*3;
        else if (argument[1]==4) return y_start - y_size*4;
        else if (argument[1]==5) return y_start - y_size*4;
        else                     return -1;
}
return -1;
