if global.started {
    exit;
} else {
    line_height = string_height("A"); 
    var line = global.editor_lines[| cursor_y];

    // === Character Input ===
    if (keyboard_lastchar != "") {
        var c = keyboard_lastchar;

        // Block newlines and backspace control char from typing here
        if (c != "\r" && c != "\n" && c != chr(8) && c != chr(vk_escape) && c != "\t"){
            // Limit typing so it doesn’t exceed editor_w
            var preview = string_insert(c, line, cursor_x + 1);
            if (string_width(preview) < editor_w - 10) {
                line = preview;
                global.editor_lines[| cursor_y] = line;
                cursor_x++;
            }
        }
        keyboard_lastchar = "";
    }
	
	// === Tab Key (Insert 4 spaces) ===
	if (keyboard_check_pressed(vk_tab)) {
	    var tab_spaces = "    ";
	    var preview = string_insert(tab_spaces, line, cursor_x + 1);
	    if (string_width(preview) < editor_w - 10) {
	        line = preview;
	        global.editor_lines[| cursor_y] = line;
	        cursor_x += string_length(tab_spaces);
	    }
	}

    // === Backspace ===
    if (keyboard_check(vk_backspace)) {
        if (keyboard_check_pressed(vk_backspace)) {
            backspace_hold = 0; // reset timer on first press
            // perform backspace immediately
            backspace_action();
        } else {
            backspace_hold++;
            if (backspace_hold > repeat_delay && (backspace_hold - repeat_delay) mod repeat_rate == 0) {
                backspace_action();
            }
        }
    } else {
        backspace_hold = 0;
    }

    // === Delete ===
    if (keyboard_check_pressed(vk_delete)) {
        if (cursor_x < string_length(line)) {
            line = string_delete(line, cursor_x + 1, 1);
            global.editor_lines[| cursor_y] = line;
        }
        else if (cursor_y < ds_list_size(global.editor_lines) - 1) {
            // Merge with next line
            var next_line = global.editor_lines[| cursor_y + 1];
            global.editor_lines[| cursor_y] = line + next_line;
            ds_list_delete(global.editor_lines, cursor_y + 1);
        }
    }

    // === Enter (New Line) ===
    if (keyboard_check_pressed(vk_enter)) {
        var left = string_copy(line, 1, cursor_x);
        var right = string_copy(line, cursor_x + 1, string_length(line) - cursor_x);
        global.editor_lines[| cursor_y] = left;
        ds_list_insert(global.editor_lines, cursor_y + 1, right);
        cursor_y++;
        cursor_x = 0;
    }

    // === Navigation ===
    if (keyboard_check_pressed(vk_left)) cursor_x = max(0, cursor_x - 1);
    if (keyboard_check_pressed(vk_right)) cursor_x = min(string_length(global.editor_lines[| cursor_y]), cursor_x + 1);
    if (keyboard_check_pressed(vk_up)) {
        if (cursor_y > 0) {
            cursor_y--;
            cursor_x = min(cursor_x, string_length(global.editor_lines[| cursor_y]));
        }
    }
    if (keyboard_check_pressed(vk_down)) {
        if (cursor_y < ds_list_size(global.editor_lines) - 1) {
            cursor_y++;
            cursor_x = min(cursor_x, string_length(global.editor_lines[| cursor_y]));
        }
    }

    // === Mouse Scroll ===
    //if (mouse_wheel_up()) scroll_y = max(0, scroll_y - line_height);
    //if (mouse_wheel_down()) scroll_y += line_height;

    // === Blink ===
    blink_timer++;
    if (blink_timer > game_get_speed(gamespeed_fps) / 2) {
        blink_timer = 0;
        blink_state = !blink_state;
    }

    // === Shortcuts ===

    // Jump to start of line (Shift + Left)
    if (keyboard_check(vk_shift) && keyboard_check_pressed(vk_left)) {
        cursor_x = 0;
    }

    // Jump to end of line (Shift + Right)
    if (keyboard_check(vk_shift) && keyboard_check_pressed(vk_right)) {
        cursor_x = string_length(global.editor_lines[| cursor_y]);
    }

    // Delete whole line (Ctrl + L)
    if (keyboard_check(vk_control) && keyboard_check_pressed(ord("L"))) {
        if (ds_list_size(global.editor_lines) > 1) {
            ds_list_delete(global.editor_lines, cursor_y);

            // Clamp cursor_y
            cursor_y = clamp(cursor_y, 0, ds_list_size(global.editor_lines) - 1);
        } else {
            global.editor_lines[| 0] = "";
            cursor_x = 0;
        }
    }

    // Delete everything (Ctrl + X)
    if (keyboard_check(vk_control) && keyboard_check_pressed(ord("X"))) {
        ds_list_clear(global.editor_lines);
        ds_list_add(global.editor_lines, "");
        cursor_x = 0;
        cursor_y = 0;
    }
}