extends Node
#music mananger

const MUSIC = preload("uid://dffgirja7c86e")
const music_loop_time = 12.3

var saved_audio_player : AudioStreamPlayer

func start():
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = MUSIC
	audio_player.volume_db = -23
	audio_player.pitch_scale = 0.95
	add_child(audio_player)
	audio_player.play()
	
	await get_tree().create_timer(42).timeout
	audio_player.queue_free()
	_play_loop()
	var endless_timer:= Timer.new()
	endless_timer.wait_time = 28
	add_child(endless_timer)
	endless_timer.start()
	endless_timer.timeout.connect(_play_loop)
	
func _play_loop():
	
	if not saved_audio_player:
		saved_audio_player = AudioStreamPlayer.new()
		saved_audio_player.stream = MUSIC
		saved_audio_player.pitch_scale = 0.95
		saved_audio_player.volume_db = -23
		add_child(saved_audio_player)
	saved_audio_player.play(14)
