extends CanvasLayer

export(String, FILE) var level

onready var start_btn = $MainMenu/MarginContainer/VBoxContainer/StartBtn
onready var howtoplay_menu = $HowToPlayPopup
onready var controls_menu = $ControlsPopup
onready var settings_menu = $SettingsMenu

func _ready():
	start_btn.grab_focus()
	Music.stream = load("res://src/sfx/env_loops/35-11 Water, Lake Water Lapping On Rock Shore, Medium.wav") 
	Music.play()

func _on_StartBtn_pressed():
	get_tree().change_scene("res://levels/world_1.tscn")
	Music.stop()
	
func _on_HowToPlayBtn_pressed():
	howtoplay_menu.popup_centered()
	
func _on_ControlsBtn_pressed():
	controls_menu.popup_centered()
	
func _on_SettingsBtn_pressed():
	settings_menu.popup_centered()
	
func _on_QuitBtn_pressed():
	get_tree().quit()


