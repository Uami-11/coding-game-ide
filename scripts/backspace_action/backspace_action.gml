function backspace_action() {
    if (cursor_x > 0) {
        var line = global.editor_lines[| cursor_y];
        line = string_delete(line, cursor_x, 1);
        global.editor_lines[| cursor_y] = line;
        cursor_x--;
    } else if (cursor_y > 0) {
        var prev_line = global.editor_lines[| cursor_y - 1];
        var line = global.editor_lines[| cursor_y];
        cursor_x = string_length(prev_line);
        global.editor_lines[| cursor_y - 1] = prev_line + line;
        ds_list_delete(global.editor_lines, cursor_y);
        cursor_y--;
    }
}

function Stepped(_num) {
    // Move in current facing direction
    var move_amount = _num;
    x += lengthdir_x(move_amount, image_angle);
    y += lengthdir_y(move_amount, image_angle);
}

function Turned(_num) {
    // Rotate by given degrees
    image_angle += _num;
}

function editor_insert_text(text) {
    if (!global.started) {
        var line = global.editor_lines[| obj_text_editor.cursor_y];
        var preview = string_insert(text, line, obj_text_editor.cursor_x + 1);

        // Calculate width of text after insertion
        var text_width = string_width(preview);

        // Only insert if it fits within editor width
        if (text_width < obj_text_editor.editor_w - 10) {
            global.editor_lines[| obj_text_editor.cursor_y] = preview;
            obj_text_editor.cursor_x += string_length(text);
        } else {
            // Optional: trim text so it fits
            var allowed_width = obj_text_editor.editor_w - 10 - string_width(line);
            var added_text = "";

            // Build partial string that fits
            for (var i = 1; i <= string_length(text); i++) {
                var partial = string_copy(text, 1, i);
                if (string_width(line + partial) < obj_text_editor.editor_w - 10) {
                    added_text = partial;
                } else break;
            }

            if (added_text != "") {
                line = string_insert(added_text, line, obj_text_editor.cursor_x + 1);
                global.editor_lines[| obj_text_editor.cursor_y] = line;
                obj_text_editor.cursor_x += string_length(added_text);
            }
        }
    }
}
