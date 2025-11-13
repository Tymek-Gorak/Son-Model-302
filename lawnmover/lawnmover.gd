extends CharacterBody2D

const MAX_SPEED = 150
const DRIFT_MAX_SPEED = 50
const ACCELARATION = 150
const DECCELARATION = 350
const DRIFT_ACCELARATION = 50

const ROTATION_SPEED = 2
const DRIFT_ROTATION_SPEED = 2.8

const LOOK_OFFSET = 60
const LOOK_SPEED = .9

var directional_sprites : Dictionary[float, int] = {
	0 : 0,
	PI / 4 : 1,
	PI / 2 : 2,
	PI * 3 / 4 : 3,
	PI : 4,
	PI * 5 / 4 : 5,
	PI * 3 / 2 : 6,
	PI * 7 / 4 : 7,
}

@onready var camera_2d: Camera2D = %Camera2D
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var cpu_particles_2d: CPUParticles2D = %CPUParticles2D

var rotation_direction := Vector2.ZERO
var is_drifting := false

func _ready() -> void:
	if visible: start_ryk()

func start_ryk():
	if %RykStart.playing or %RykSus.playing: return
	%RykStart.play()
	await get_tree().create_timer(1.0).timeout
	%RykStart.stop()
	%RykSus.play()
	%RykSus.finished.connect(func():%RykSus.play())
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		rotation_direction += Vector2.RIGHT
	if event.is_action_released("left"):
		rotation_direction -= Vector2.RIGHT
	if event.is_action_pressed("right"): 
		rotation_direction += Vector2.LEFT
	if event.is_action_released("right"):
		rotation_direction -= Vector2.LEFT
	rotation_direction = rotation_direction.clamp(-Vector2.ONE,Vector2.ONE)
	
	if event.is_action_pressed("drift") and visible:
		%drift.play()
		%drift.pitch_scale = 1 + randf_range(-0.2, 0.2)
		is_drifting = true
	if event.is_action_released("drift") and visible:
		%drift.stop()
		is_drifting = false
		is_drifting = false
	
func _physics_process(delta: float) -> void:
	if not visible: return
	if is_drifting:
		if not rotation_direction.is_zero_approx(): rotate((rotation_direction.angle() - PI/2) * DRIFT_ROTATION_SPEED * delta)
	else:
		if not rotation_direction.is_zero_approx(): rotate((rotation_direction.angle() - PI/2) * ROTATION_SPEED * delta)
	sprite_2d.rotation = -rotation
	
	if is_drifting:
		velocity = velocity.move_toward(Vector2.RIGHT.rotated(rotation) * DRIFT_MAX_SPEED, DRIFT_ACCELARATION * delta)
	else:
		if velocity.dot(Vector2.from_angle(rotation)) >0.3:
			velocity = velocity.move_toward(Vector2.RIGHT.rotated(rotation) * MAX_SPEED, ACCELARATION * delta)
		else:
			velocity = velocity.move_toward(Vector2.RIGHT.rotated(rotation) * MAX_SPEED, DECCELARATION * delta)
			
	#velocity = velocity.rotated(rotation -PI/2)
	if get_last_slide_collision() and velocity.length() >=50:
		var collision : KinematicCollision2D = get_last_slide_collision()
		velocity = velocity.bounce(collision.get_normal()) * 1
		%bounce.pitch_scale = 1 + randf_range(-0.2, 0.2)
		%bounce.play()

		
	move_and_slide()
	
		

func _process(delta: float) -> void:
	if not visible: return
	cpu_particles_2d.rotation = -rotation
	camera_2d.offset = camera_2d.offset.lerp(Vector2.from_angle(rotation) * LOOK_OFFSET, LOOK_SPEED * delta)
	var facing_direction := floori(rotation / (PI/4))
	while facing_direction < 0 : facing_direction += 8
	sprite_2d.frame = directional_sprites[facing_direction * PI/4]
	
	match facing_direction:
		0:
			cpu_particles_2d.direction = Vector2(-1, -1)
		1:
			cpu_particles_2d.direction = Vector2(-0.585, -1)
		2:
			cpu_particles_2d.direction = Vector2(0, -1)
		3:
			cpu_particles_2d.direction = Vector2(0.585, -1)
		4:
			cpu_particles_2d.direction = Vector2(1, -1)
		5:
			cpu_particles_2d.direction = Vector2(4.575, -1)
		6:
			cpu_particles_2d.direction = Vector2(0, 1)
		7:
			cpu_particles_2d.direction = Vector2(-4.575, -1)


func _on_visibility_changed() -> void:
	if visible:
		reparent(get_tree().get_first_node_in_group("Garden"))
		z_index = 0
