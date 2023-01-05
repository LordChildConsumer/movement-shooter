class_name Actor extends KinematicBody;

#
# Exports
#
export(int) var max_health := 100;
export(int) var base_damage := 10;
export(float) var move_speed := 25;
export(float) var jump_force := 7.5;

export(Vector3) var gravity_dir: Vector3 = ProjectSettings.get_setting("physics/3d/default_gravity_vector");
export(float) var gravity_accel: float = ProjectSettings.get_setting("physics/3d/default_gravity");

#
# Variables
#
var hp := max_health;
var velocity := Vector3();

#
# Constants
#
const MAXFALLSPEED := 50;
