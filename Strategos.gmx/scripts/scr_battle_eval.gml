///scr_battle_eval(attacker_type, defender_type) returns 0 if the attacker won, 1 if the defender won, 2 in case of tie
if (argument[0]==tile_type.miner_3 && argument[1]==tile_type.bomb) return 0; //miners beat bombs
if (argument[0]==tile_type.spy && argument[1]==tile_type.marshal_10) return 0; //spy beats marshal
if (argument[0] > argument[1]) return 0;
else if (argument[0] == argument[1]) return 2;
else return 1;
