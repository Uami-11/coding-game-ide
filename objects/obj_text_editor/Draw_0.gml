
draw_set_font(fnt_editor);
draw_set_color(c_white);

// Draw box background
draw_set_alpha(0.1);
draw_rectangle(editor_x, editor_y, editor_x + editor_w, editor_y + editor_h, false);
draw_set_alpha(1);

// Draw lines
for (var i = 0; i < ds_list_size(global.editor_lines); i++) {
    var draw_y = editor_y + i * line_height - scroll_y;
    if (draw_y >= editor_y && draw_y < editor_y + editor_h) {
        draw_text(editor_x + 4, draw_y, global.editor_lines[| i]);
    }
}

// Draw cursor
var before_text = string_copy(global.editor_lines[| cursor_y], 1, cursor_x);
var cursor_px = editor_x + 4 + string_width(before_text);
var cursor_py = editor_y + cursor_y * line_height - scroll_y;

if (blink_state) {
    draw_line(cursor_px, cursor_py, cursor_px, cursor_py + line_height);
}
