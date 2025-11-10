extends Label

func _ready() -> void:
	WeedManager.weed_amount_changed.connect(_on_weed_amount_changed)
	text = str(WeedManager.weed_count)
	
func _on_weed_amount_changed(amount : int):
	text = str(amount)
