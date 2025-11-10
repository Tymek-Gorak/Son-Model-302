extends Node2D

const BLUE_LARGE = preload("uid://br7srllnx3suk")

func _ready() -> void:
	WeedManager.phase_two_start.connect(_spawn_blue_flower)
		
func _spawn_blue_flower():
	var blue : Flower = BLUE_LARGE.instantiate()
	get_parent().add_child.call_deferred(blue)
	blue.position = position
		
	
