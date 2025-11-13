extends Node2D

@onready var buffer: Timer = %Buffer
@onready var dziaszios_animation_player: AnimationPlayer = %DziasziosAnimationPlayer
@onready var kiddos_animation_player: AnimationPlayer = %KiddosAnimationPlayer
@onready var dialogue_box: DialogueBox = %DialogueBox
@onready var wide_eyed_kiddos: Sprite2D = %WideEyedKiddos
@onready var audio_stream_player_2d: AudioStreamPlayer2D = %AudioStreamPlayer2D

var cutscene_progress := -1	

func _ready() -> void:
	var main_camera : Camera2D = get_tree().get_first_node_in_group("MainCamera")
	var tween = create_tween()
	tween.tween_property(main_camera,"zoom", Vector2.ONE * 1.4, 0.6).set_ease(Tween.EASE_OUT)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		continue_cutscene()

func continue_cutscene():
	if not buffer.is_stopped(): return
	buffer.start()
	cutscene_progress+=1
	match cutscene_progress:
		0:
			dziaszios_animation_player.play("wybazce_sei")
			await dziaszios_animation_player.animation_finished
			if cutscene_progress != 0: return
			dziaszios_animation_player.play("idle")
			dialogue_box.write_emoji_text("[img]res://sziadzio/plant_icon.png[/img][img]res://sziadzio/fence_icon.png[/img][img]res://sziadzio/plant_icon.png[/img]")
			play_dziad_sound()
			await get_tree().create_timer(2.7).timeout
			if cutscene_progress != 0: return
			dialogue_box.write_emoji_text("[img]res://sziadzio/weed_plant_1_icon.png[/img][img]res://sziadzio/fence_icon.png[/img][img]res://sziadzio/plant_icon.png[/img]",0)
			play_dziad_sound()
			await get_tree().create_timer(0.6).timeout
			if cutscene_progress != 0: return
			dialogue_box.write_emoji_text("[img]res://sziadzio/weed_plant_1_icon.png[/img][img]res://sziadzio/weed_fence_icon.png[/img][img]res://sziadzio/plant_icon.png[/img]",0)
			await get_tree().create_timer(0.6).timeout
			if cutscene_progress != 0: return
			dialogue_box.write_emoji_text("[img]res://sziadzio/weed_plant_1_icon.png[/img][img]res://sziadzio/weed_fence_icon.png[/img][img]res://sziadzio/weed_plant_2_icon.png[/img]",0)
		1:
			dziaszios_animation_player.play("idle")
			dialogue_box.write_emoji_text("[img]res://sziadzio/grandpa_icon.png[/img][img]res://sziadzio/lawnmover_icon.png[/img]")
			play_dziad_sound()
		2:
			dziaszios_animation_player.play("idle")
			dialogue_box.write_emoji_text("Ugh...", 0.1)
			play_dziad_sound()
		3:
			dziaszios_animation_player.play("idle")
			dialogue_box.write_emoji_text("...")
			kiddos_animation_player.get_animation("jumping").loop_mode = Animation.LOOP_NONE
			await kiddos_animation_player.animation_finished
			if cutscene_progress != 3: return
			dialogue_box.write_emoji_text()
			dziaszios_animation_player.play("idea")
			kiddos_animation_player.play("stop")
			dziaszios_animation_player.queue("wybazce_sei")
			await  dziaszios_animation_player.animation_finished
			if cutscene_progress != 3: return
			dziaszios_animation_player.play("idle")
			kiddos_animation_player.play("step")
			await  kiddos_animation_player.animation_finished
			if cutscene_progress != 3: return
			kiddos_animation_player.play("idle2")
			dialogue_box.write_emoji_text("[img]res://sziadzio/kid_icon.png[/img][img]res://sziadzio/arrow_icon.png[/img][img]res://sziadzio/weeds_icon.png[/img]")
			play_dziad_sound()
		4:
			dialogue_box.write_emoji_text()
			dziaszios_animation_player.play("transformation")
			kiddos_animation_player.play("idle2")
			await  get_tree().create_timer(1.6).timeout
			if cutscene_progress != 4: return
			dziaszios_animation_player.play("transformation end")
			dziaszios_animation_player.queue("idle")
			kiddos_animation_player.play("transformation")
			await kiddos_animation_player.animation_finished
			if cutscene_progress != 4: return
			dialogue_box.write_emoji_text("[img]res://sziadzio/kid_icon.png[/img][img]res://sziadzio/arrow_icon.png[/img][img]res://sziadzio/weeds_icon.png[/img]")
			play_dziad_sound()
		5:
			dialogue_box.write_emoji_text()
			dziaszios_animation_player.play("slep")
			kiddos_animation_player.play("transformation",-1,0,true)
			var main_camera : Camera2D = get_tree().get_first_node_in_group("MainCamera")
			var tween = create_tween()
			tween.tween_property(main_camera,"zoom", Vector2.ONE, 0.3).set_ease(Tween.EASE_OUT)
			await tween.finished
			%Lawnmover.show()
			if audio_stream_player_2d.playing:
				hide()
				await audio_stream_player_2d.finished
			get_tree().call_group("CutsceneEnd", "show")
			call_deferred("queue_free")

func play_dziad_sound(play_from := 0.0):
	audio_stream_player_2d.pitch_scale =  1.0 + randf_range(-0.03, 0.03)
	audio_stream_player_2d.play(play_from)
