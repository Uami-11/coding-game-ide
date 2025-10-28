if global.started and (obj_player.start_x == obj_player.x and obj_player.start_y == obj_player.y) {
	collected = false;
	global.CheeseCoutner = 0;
} 

if !collected {
	visible = true
}
distance = int64(point_distance(x, y, obj_player.x, obj_player.y)/32);