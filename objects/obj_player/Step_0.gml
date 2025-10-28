// Detect when execution starts
if (global.started && current_line == 0 && !command_active) {
    // Reset position and angle
    x = start_x;
    y = start_y;
    image_angle = start_angle;

    // Reset execution variables
    current_line = 0;
    command_active = false;
    cmd_type = "";
    cmd_target = 0;
    cmd_progress = 0;
}


if (global.started) {

    // If no command is active, fetch the next one
    if (!command_active && current_line < ds_list_size(global.editor_lines)) {
        var line = global.editor_lines[| current_line];
        var words = string_split_ext(string_trim(line), [" "], true);

        if (array_length(words) == 2) {
            var cmd = string_lower(words[0]);
            try {
				var val = real(words[1]);
			} catch(_exception){
				global.started = false;
			}
			

            if ((cmd == "step" || cmd == "turn") and global.started) {
                cmd_type = cmd;
                cmd_target = val;
                cmd_progress = 0;
                command_active = true;
            } else {
                global.started = false; // invalid command
            }
        } else {
            global.started = false; // malformed line
        }
    }

    // If a command is active, perform it gradually
    if (command_active) {
        if (cmd_type == "step") {
		    var total_dist = abs(cmd_target) * 32; // total pixels to move
		    var dir_angle = image_angle;

		    // If cmd_target is negative, move backwards
		    if (cmd_target < 0) {
		        dir_angle += 180;
		    }

		    var dx = lengthdir_x(cmd_speed, dir_angle);
		    var dy = lengthdir_y(cmd_speed, dir_angle);

		    x += dx;
		    y += dy;
		    cmd_progress += cmd_speed;

		    if (cmd_progress >= total_dist) {
		        // Snap to grid (optional, if you want grid movement)
		        x = round(x / 32) * 32;
		        y = round(y / 32) * 32;

		        command_active = false;
		        current_line++;
		    }
		}

        else if (cmd_type == "turn") {
            var turn_amount = min(cmd_speed, abs(cmd_target) - cmd_progress);
            var dir = sign(cmd_target); // direction of rotation
            image_angle += dir * turn_amount;
            cmd_progress += turn_amount;

            if (cmd_progress >= abs(cmd_target)) {
                command_active = false;
                current_line++;
            }
        }
    }

    // If we've reached the end, stop
    if (current_line >= ds_list_size(global.editor_lines)) {
        global.started = false;
        current_line = 0;
    }
}
