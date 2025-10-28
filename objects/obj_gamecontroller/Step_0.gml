if (global.started) {
	global.CheeseCoutner = 0;
    for (var i = 0; i < ds_list_size(global.editor_lines); i++) {
        var line = global.editor_lines[| i];
        var words = string_split_ext(string_trim(line), [" "], true); // split by space, remove empties

        // Must have exactly 2 words: command + number
        if (array_length(words) == 2) {
            var cmd = string_lower(words[0]);
            var val = string_trim(words[1]);

            try {
                var num = real(val);

                if (cmd == "step") {
                    Stepped(num); // pass number to your function
                }
                else if (cmd == "turn") {
                    Turned(num);
                }
                else {
                    // Invalid command
                    global.started = false;
                    break;
                }
            }
            catch (e) {
                // Not a valid number (conversion failed)
                global.started = false;
                break;
            }
        }
        else {
            // Wrong number of words
            global.started = false;
            break;
        }
    }
}