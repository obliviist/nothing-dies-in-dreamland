extends Control

var is_paused = false setget set_is_paused

onready var settings_menu = $SettingsMenu

func _ready():
	Music.stream = load("res://src/music/menu_loop16.wav") 
	Music.play()

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused
		
func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_ResumeBtn_pressed():
	self.is_paused = false
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	Music.stop()
	Music.stream = load("res://src/music/level1_loop16.wav") 
	Music.play()

func _on_SettingsBtn_pressed():
	settings_menu.popup_centered()

func _on_QuitBtn_pressed():
	get_tree().quit()
