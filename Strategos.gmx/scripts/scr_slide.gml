///scr_slide(slide_x, slide_y, depth, max_speed, min_speed, frames) where last 4 are optional.
// Frames dictates ideal # of frames to transit in (bounded by min and max speeds)
// for use from obj_base_tile

var slide_max_speed = params.default_max_slide;
var slide_min_speed = params.default_min_slide;
var slide_duration = params.default_slide_time;
depth = params.default_slide_depth;

if (argument_count >= 3) depth = argument[2];
if (argument_count >= 4) slide_max_speed = argument[3];
if (argument_count >= 5) slide_min_speed = argument[4];
if (argument_count >= 6) slide_duration = argument[5];

sliding = true;
slide_x = argument[0];
slide_y = argument[1];
move_towards_point(slide_x, slide_y, max(slide_min_speed, min(distance_to_point(slide_x, slide_y)/slide_duration, slide_max_speed)));
