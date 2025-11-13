extends PanelContainer
class_name DialogueBox

@onready var rich_text_label: RichTextLabel = %RichTextLabel

var tween : Tween

func _ready() -> void:
	write_emoji_text()
	#write_emoji_text("[img]res://sziadzio/kid_icon.png[/img][img]res://sziadzio/lawnmover_icon.png[/img][img]res://sziadzio/weed_fence_icon.png[/img]")

func write_emoji_text(bbtext := "", delay := .7):
	if bbtext == "":
		rich_text_label.text = bbtext
		hide()
		return
	show()
	rich_text_label.visible_characters = 0
	rich_text_label.text = bbtext
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(rich_text_label,"visible_characters",rich_text_label.text.length(),delay*rich_text_label.text.length())
	
