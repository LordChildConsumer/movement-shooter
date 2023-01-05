class_name Player extends Actor;

#
# Node References
#
onready var head := $Head;

#
# Variables
#
var gravity_vec := Vector3();

#
# Constants
#
const ACCEL = 0.25;

####################
### Player Logic ###
####################

func _init() -> void:
	pass;

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _input(event: InputEvent) -> void:
	## DEBUG QUIT
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	#
	# Mouse Look
	#
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mouse_sens: float = PlayerConf.get_setting("controls", "mouse_sens");
		rotate_y(-event.relative.x * mouse_sens);
		head.rotate_x(-event.relative.y * mouse_sens);
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90));

func _physics_process(delta: float) -> void:
	#
	# Horizontal Movement
	#
	
	## Get horizontal movement based on input
	## transform.basis.xform makes h_dir relative to the player's transform
	var h_dir := transform.basis.xform(Vector3(
		Input.get_action_strength("player_right") - Input.get_action_strength("player_left"),
		0.0,
		Input.get_action_strength("player_backward") - Input.get_action_strength("player_forward")
	).normalized() * move_speed);
	
	## Horizontal acceleration
	if velocity != h_dir:
		velocity = lerp(velocity, h_dir, ACCEL);
	
	#
	# Vertical Movement
	#
	
	if !is_on_floor():
		## Apply Gravity
		gravity_vec += gravity_dir * gravity_accel * delta;
		gravity_vec.y = clamp(gravity_vec.y, -MAXFALLSPEED, MAXFALLSPEED);
	else:
		gravity_vec = -get_floor_normal();
		if Input.is_action_just_pressed("player_jump"):
			## Jump
			gravity_vec = Vector3.UP * jump_force;
	
	## Apply jumping/gravity
	velocity += gravity_vec;
	
	velocity = move_and_slide(velocity, Vector3.UP);
