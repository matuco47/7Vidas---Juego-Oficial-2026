extends Node


var music_player: AudioStreamPlayer


func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	music_player.bus = "Master"

	music_player.stream = preload(
		"res://assets/MUSIC_Intro_Loopeable_7V.wav"
	)

	# Hacer loop manualmente
	music_player.finished.connect(
		_on_music_finished
	)

	play_menu_music()


func play_menu_music() -> void:
	if not music_player.playing:
		music_player.play()


func stop_menu_music() -> void:
	if music_player.playing:
		music_player.stop()


func _on_music_finished() -> void:
	music_player.play()
