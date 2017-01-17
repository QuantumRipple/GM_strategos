//scr_server_check_defeat(player) where player indicates who just moved. Returns 0 if no defeat, 1 if A lost due to flag captured, 2 if B lost due to flag captured, 3 if A can't move, 4 if B can't move
if (captured_a[tile_type.flag]==1) return 1;
if (captured_b[tile_type.flag]==1) return 2;
var amoves = false;
var bmoves = false;
for (var i = 0; i < 10; ++i) {
    for (var j = 0; j < 8; ++j) {
        if ((amoves==false && board[i,j].owner==0) || (bmoves=false && board[i,j].owner==1)) { //don't bother checking if we aren't looking for this player
            if (board[i,j].type>=tile_type.spy && board[i,j].type<=tile_type.marshal_10) { //movable pieces
                if ((i > 0 && (board[i-1,j].type==tile_type.blank || (board[i,j].owner+board[i-1,j].owner)==1)) || //check left, we can move (or try at least) if the space is empty or has an enemy
                    (i < 9 && (board[i+1,j].type==tile_type.blank || (board[i,j].owner+board[i+1,j].owner)==1)) || //check right
                    (j > 0 && (board[i,j-1].type==tile_type.blank || (board[i,j].owner+board[i,j-1].owner)==1)) || //check up
                    (j < 7 && (board[i,j+1].type==tile_type.blank || (board[i,j].owner+board[i,j+1].owner)==1))) {  //check down
                    if (board[i,j].owner==0) amoves=true; else bmoves=true;
                }
            }
        }
        if (amoves && bmoves) break; //improve efficiency
    }
    if (amoves && bmoves) break; //improve efficiency
}

if (amoves == false) {
    if (argument[0]==0 && bmoves==false) { //player A made the move, so player B should be checked first, just in case the last 2 movable pieces tied each other
        return 4;
    } else {
        return 3;
    }
} else if (bmoves == false) {
    return 4; 
} else {
    return 0;
}
