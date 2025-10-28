
if global.started
{
	global.started = false;
	show_debug_message("stopped mannually")
} else {
	global.started = true;
	show_debug_message("started manually")
}

audio_sound_pitch(snd_button, 1);
audio_play_sound(snd_button, 10, false)