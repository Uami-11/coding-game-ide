if (keyboard_check_pressed(vk_f4) or  (keyboard_check(vk_alt) and keyboard_check(vk_enter))){

	window_set_fullscreen(fill);
	fill = !fill

}

if (keyboard_check(vk_escape)){
	quitTimer += 1/game_get_speed(gamespeed_fps);
	if (quitTimer >= 3){
		game_end();
	}
	quitting = true;
}
if (keyboard_check_released(vk_escape)){
	quitTimer = 0;
	quitting = false;
}