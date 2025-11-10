extends Area2D
class_name Flower

const random_offset = 1

@export var weed_sprite := AtlasTexture
@export var is_weed := false
@export var corrupt_time := 10.0

@onready var corruption_timer: Timer = %CorruptionTimer
@onready var sprite_2d: AnimatedSprite2D = %Sprite2D
@onready var weed_zone_collision: CollisionShape2D = %WeedZoneCollision

var corruption_tween : Tween

func _ready() -> void:
	#random offset
	position += Vector2(randi_range(-random_offset, random_offset),randi_range(-random_offset, random_offset))
	corrupt_time = randf_range(corrupt_time - .999, corrupt_time + 0.999)
	corruption_timer.wait_time = corrupt_time
	if is_weed: _turn_into_weed()
	body_entered.connect(_on_player_entered)
	area_entered.connect(_on_weed_zone_entered)
	area_exited.connect(_stop_corruption)
	sprite_2d.speed_scale = randf_range(0.95,1.05)
	
func _on_player_entered(_body : Node2D):
	WeedManager.mow_plant()
	if is_weed: WeedManager.weed_count -= 1
	queue_free()

func _on_weed_zone_entered(_area : Area2D):
	if not corruption_timer.is_stopped() or is_weed: return
	corruption_timer.start()
	
	corruption_tween = create_tween()
	corruption_tween.tween_property(self, "modulate", Color.LIME, corruption_timer.wait_time)
	corruption_tween.parallel().tween_property(self, "scale", Vector2.ONE * 1.3, corruption_timer.wait_time * 2)

func _stop_corruption(_area : Area2D):
	await get_tree().physics_frame
	if get_overlapping_areas().size() > 0 or corruption_timer.is_stopped(): return
	corruption_tween.kill()
	scale = Vector2.ONE
	modulate = Color.WHITE
	corruption_timer.stop()

func _turn_into_weed():
	is_weed = true
	weed_zone_collision.disabled = false
	sprite_2d.queue_free()
	$WeedTextureSprite.texture = weed_sprite
	$WeedTextureSprite.show()
	WeedManager.add_weed_spot(self)
	WeedManager.weed_count += 1
	var tween := create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * 0.3, 60)
	tween.tween_callback(func(): 
		WeedManager.weed_count -= 1
		queue_free())
