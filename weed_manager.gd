extends Node
# WEED Manager

signal weed_amount_changed(amount : int)
signal phase_two_start()
signal win()

const PLANT_MOWING_SOUND = preload("uid://cm4qkm8l2xc30")
const WAYPOINT_MARKER = preload("uid://e0ymkdqpg4kj")
const FENCE_BREAK = preload("uid://dii7hw1x4upab")

var FlowerSprites : Dictionary[FlowerTypes, Array]= {
	
}

enum FlowerTypes {RED_FLOWER,SUNFLOWER}

var audio_player_count := 0
var audio_player_count_fence := 0
var audio_player_max := 8
var audio_player_max_fence := 8
var is_phase_two := false
var weed_spots : Array[Node2D]
var weed_count : int :
	set(amount):
		if amount == 0 and weed_count > 0:
			if not is_phase_two:
				phase_two_start.emit()
				is_phase_two = true
			else:
				win.emit()
		
		weed_count = amount
		weed_amount_changed.emit(amount)
var starting_plants : int
	
		
func _ready() -> void:
	await get_tree().create_timer(0.3).timeout
	starting_plants = get_tree().get_node_count_in_group("flower")
	
func add_weed_spot(spot : Node2D):
	weed_spots.append(spot)
	var marker := WAYPOINT_MARKER.instantiate()
	spot.add_child(marker)

func mow_plant():
	if audio_player_count >= audio_player_max: return
	audio_player_count+=1
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = PLANT_MOWING_SOUND
	audio_player.volume_db = -18
	audio_player.pitch_scale = 1.0 + randf_range(-0.2, 0.2)
	add_child(audio_player)
	audio_player.play()
	await get_tree().create_timer(.75).timeout
	audio_player.queue_free()
	audio_player_count-=1

func mow_fence():
	if audio_player_count_fence >= audio_player_max_fence: return
	audio_player_count_fence+=1
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = FENCE_BREAK
	audio_player.volume_db = -23
	audio_player.pitch_scale = 1.0 + randf_range(-0.2, 0.2)
	add_child(audio_player)
	audio_player.play()
	await get_tree().create_timer(.9).timeout
	audio_player.queue_free()
	audio_player_count_fence-=1
