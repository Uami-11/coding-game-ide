

if !collected {
	global.CheeseCoutner++;
	visible = false;
	collected = true
	audio_play_sound(snd_collect, 10, false)
}


