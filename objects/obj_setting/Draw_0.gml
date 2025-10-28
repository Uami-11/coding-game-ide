depth = -999

if (quitting) {
    draw_set_font(fnt_editor);
    if (quitTimer < 2) {draw_set_color(c_gray)}
    else {draw_set_color(c_white);}
    draw_text(15, display_get_height() - 100, "Quitting...");
}