
global.editor_lines = ds_list_create(); 
ds_list_add(global.editor_lines, ""); // Start with empty line

cursor_x = 0;  // character index inside line
cursor_y = 0;  // line index
blink_timer = 0;
blink_state = true;

editor_x = room_width - 960; // editor box starts at right side
editor_y = 0;
editor_w = 960;
editor_h = 1080;

scroll_y = 0; // vertical scroll offset
line_height = string_height("A"); 

backspace_hold = 0;
repeat_delay = game_get_speed(gamespeed_fps) / 5;   // ~0.2s before repeating starts
repeat_rate  = game_get_speed(gamespeed_fps) / 15;  // repeat every ~0.066s afterwards