class_name Weapon extends Spatial;

#
# Exports
#
export(float) var attack_delay := 1.0;
export(float) var dmg_mult := 1.0;

#
# Node References
#
onready var anim := $AnimationPlayer;
