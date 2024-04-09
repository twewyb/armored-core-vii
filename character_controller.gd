extends CharacterBody3D

@export var pcam :PhantomCamera3D

@export var speed = 5
@export var v_speed = 30
@export var jumps = 3
@export var jump_velocity = 5
@export var thrust_multiplier = 1

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravitycoef = 1

var thrust_buffering :float = .6
var thrust_timer :Timer
var vertical_buffering:float = .6
var vertical_timer:Timer

var mouse_sensitivity: float = 0.05
var min_yaw: float = 0
var max_yaw: float = 360
var min_pitch: float = -89.9
var max_pitch: float = 50

func _unhandled_input(event) -> void:
	if event is InputEventMouseMotion:
		var pcam_rotation_degrees: Vector3

		pcam_rotation_degrees = pcam.get_third_person_rotation_degrees()
		pcam_rotation_degrees.x -= event.relative.y * mouse_sensitivity
		pcam_rotation_degrees.x = clampf(pcam_rotation_degrees.x, min_pitch, max_pitch)
		pcam_rotation_degrees.y -= event.relative.x * mouse_sensitivity
		pcam_rotation_degrees.y = wrapf(pcam_rotation_degrees.y, min_yaw, max_yaw)
		pcam.set_third_person_rotation_degrees(pcam_rotation_degrees)
	
	if event.is_action_pressed("thrust"):
		thrust_timer = Timer.new()
		thrust_timer.autostart=false
		thrust_timer.one_shot=true
		add_child(thrust_timer)
		thrust_timer.start(thrust_buffering)
		await thrust_timer.timeout
		_dash(true)
		
	if event.is_action_released("thrust"):
		if thrust_timer.time_left>0:
			_dodge()
		else:
			_dash(false)
		thrust_timer.queue_free()

func _physics_process(delta):
	var input_direction = Input.get_vector("left","right","forward","backward")
	_camera_damping(input_direction)
	var direction = (transform.basis * Vector3(input_direction.x, 0, input_direction.y)).rotated(Vector3.UP,pcam.get_third_person_rotation().y).normalized()
	if direction:
		velocity.x = direction.x * speed * thrust_multiplier
		velocity.z = direction.z * speed * thrust_multiplier
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if Input.is_action_just_pressed("jump"):
		vertical_timer = Timer.new()
		vertical_timer.autostart=false
		vertical_timer.one_shot=true
		add_child(vertical_timer)
		vertical_timer.start(vertical_buffering)
		await vertical_timer.timeout
		velocity.y = 1 * v_speed
	
	if Input.is_action_just_released("jump"):
		if vertical_timer.time_left>0: 
			velocity.y = jump_velocity
		else:
			velocity.y = 0
		vertical_timer.queue_free()
	
	if not is_on_floor():
		velocity.y -= gravity *delta *gravitycoef
		
	move_and_slide()


func _dodge():
	speed = 25
	var dodge_timer = Timer.new()
	add_child(dodge_timer)
	dodge_timer.autostart=false
	dodge_timer.one_shot=true
	dodge_timer.start(.2)
	await dodge_timer.timeout
	speed = 5
	print("dodge")

func _dash(value:bool):
	if value:
		gravitycoef=0
		speed =15
	else:
		speed = 5
		gravitycoef=1
	print("dash")


func _camera_damping(dir):
	if dir.x != 0:
		pcam.set_follow_target_offset(Vector3(dir.x*2,1.1,0))
	elif dir.y !=0:
		pcam.set_follow_target_offset(Vector3(0,1.1,dir.y*-1.2))
	
	else : 
		pcam.set_follow_target_offset(Vector3(0,1.1,0))
	
	
