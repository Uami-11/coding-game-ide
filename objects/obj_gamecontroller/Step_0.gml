if (global.started) {
    global.CheeseCounter = 0;

    // Step 1: Expand any for-loops into explicit commands
    var expanded_lines = ds_list_create();

    var i = 0;
    while (i < ds_list_size(global.editor_lines)) {
        var raw_line = string_trim(global.editor_lines[| i]);

        // --- detect for loop ---
        if (string_starts_with(raw_line, "for ")) {
            var words = string_split_ext(raw_line, [" "], true);

            if (array_length(words) == 4 && words[2] == "in") {
                var loop_var = words[1];
                var array_name = words[3];

                // check if array_name exists in global.arrays
                var found = false;
                for (var j = 0; j < array_length(global.arrays); j++) {
                    if (global.arrays[j] == array_name) {
                        found = true;
                        break;
                    }
                }

                if (found) {
                    var range = variable_global_get(array_name);

                    // collect loop body (lines indented with 4 spaces)
                    var body = [];
                    var k = i + 1;
                    while (k < ds_list_size(global.editor_lines)) {
                        var next_line = global.editor_lines[| k];
                        if (string_copy(next_line, 1, 4) == "    ") {
                            array_push(body, string_delete(next_line, 1, 4)); // remove indent
                            k++;
                        } else {
                            break;
                        }
                    }

                    // expand the loop into explicit commands
                    for (var n = 0; n < range; n++) {
                        for (var b = 0; b < array_length(body); b++) {
                            var expanded = string_replace_all(body[b], loop_var, string(n));
                            ds_list_add(expanded_lines, expanded);
                        }
                    }

                    // skip loop and its body
                    i = k;
                    continue;
                } else {
                    show_debug_message("for-loop failed: " + array_name + " not found in global.arrays");
                    global.started = false;
                    ds_list_destroy(expanded_lines);
                    exit;
                }
            } else {
                show_debug_message("Invalid for-loop syntax at line " + string(i));
                global.started = false;
                ds_list_destroy(expanded_lines);
                exit;
            }
        } 
        else {
            // just a normal line, copy it directly
            ds_list_add(expanded_lines, raw_line);
            i++;
        }
    }

    // Step 2: Process expanded lines normally
    for (var i = 0; i < ds_list_size(expanded_lines); i++) {
        var line = expanded_lines[| i];
        var words = string_split_ext(string_trim(line), [" "], true);

        if (array_length(words) == 2) {
            var cmd = string_lower(words[0]);
            var val = string_trim(words[1]);

            try {
                var num = real(val);

                if (cmd == "step") {
                    Stepped(num);
                }
                else if (cmd == "turn") {
                    Turned(num);
                }
                else {
                    global.started = false;
                    break;
                }
            }
            catch (e) {
                global.started = false;
                break;
            }
        }
        else {
            global.started = false;
            break;
        }
			show_debug_message(expanded_lines)
			for (var i = 0; i < ds_list_size(expanded_lines); i += 1)
				{
				    var value = ds_list_find_value(expanded_lines, i); // Get the value at the current index
				    // Alternatively, in newer GMS versions, you can use the accessor:
				    // var value = my_list[| i]; 
				    show_debug_message("List item at index " + string(i) + ": " + string(value));
				}
    }

    // clean up
	// instead of destroying editor_lines, create a new exec_lines list
	if (ds_exists(global.exec_lines, ds_type_list)) {
	    ds_list_destroy(global.exec_lines);
	}
	global.exec_lines = expanded_lines;

}
