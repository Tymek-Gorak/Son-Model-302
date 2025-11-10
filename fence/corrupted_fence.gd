extends Area2D

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var fence_detector: RayCast2D = %FenceDetector
@onready var mow_blocker: StaticBody2D = %MowBlocker
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var atlas_texture : AtlasTexture = sprite_2d.texture


func _ready() -> void:
	await get_tree().physics_frame
	var adjecencies_direction : Array[Vector2i] = []
	for i in range(4):
		fence_detector.force_raycast_update()
		if fence_detector.is_colliding(): 
			var detector_direction := fence_detector.target_position
			adjecencies_direction.append(Vector2i(detector_direction.normalized()))
			print(adjecencies_direction, " " , name)
		fence_detector.target_position = fence_detector.target_position.rotated(PI/2)
	if adjecencies_direction == []:
		modulate = Color.NAVAJO_WHITE
	else:
		atlas_texture.region.position += Globals.fence_dictionary[adjecencies_direction] * 16
		print(atlas_texture.region)
	fence_detector.queue_free()
	await get_tree().physics_frame
	collision_shape_2d.disabled = true
	body_entered.connect(_on_mowed)
	WeedManager.phase_two_start.connect(_corrupt)
	
func _corrupt() -> void:
	if mow_blocker:
		mow_blocker.queue_free()
		collision_shape_2d.set_deferred("disabled", false)
	atlas_texture.region.position.x += 384

func _on_mowed(_player : CharacterBody2D):
	WeedManager.mow_fence()
	queue_free()
