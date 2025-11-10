extends Area2D
class_name WaypointMarker

@onready var camera : Camera2D = get_tree().get_first_node_in_group("MainCamera")
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var sprite: Sprite2D = %Sprite
@onready var starting_position := sprite.position

var margin := 10

func _ready() -> void:
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(randf()/10.0).timeout
	collision_shape_2d.disabled = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	if not get_overlapping_areas().is_empty():
		queue_free()
	else:
		collision_mask = 0
		modulate = Color.YELLOW

func _process(_delta: float) -> void:
	scale = Vector2.ONE / get_parent().scale
	sprite.position = starting_position
	if not camera: return
	var camera_dimensions := camera.get_viewport_rect().size - Vector2.ONE * margin * 2
	var camera_top_left_position := camera.get_screen_center_position() - camera_dimensions/2 
	
	sprite.global_position.x = clamp(sprite.global_position.x, camera_top_left_position.x, camera_top_left_position.x + camera_dimensions.x)
	sprite.global_position.y = clamp(sprite.global_position.y, camera_top_left_position.y, camera_top_left_position.y + camera_dimensions.y)
	if sprite.position.distance_to(starting_position) < 100 : 
		hide()
	else:
		show()
