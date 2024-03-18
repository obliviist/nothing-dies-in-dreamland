extends Popup

# Video Settings
onready var display_options = $SettingTabs/Video/MarginContainer/VideoSettings/DisplayOptionBtn
onready var vsync_btn = $SettingTabs/Video/MarginContainer/VideoSettings/VsyncBtn
onready var display_fps_btn = $SettingTabs/Video/MarginContainer/VideoSettings/DisplayFpsBtn
onready var max_fps_val = $SettingTabs/Video/MarginContainer/VideoSettings/BloomHBoxContainer/MaxFpsVal
onready var max_fps_slider = $SettingTabs/Video/MarginContainer/VideoSettings/BloomHBoxContainer/MaxFpsSlider
onready var bloom_btn = $SettingTabs/Video/MarginContainer/VideoSettings/BloomBtn
onready var brightness_slider = $SettingTabs/Video/MarginContainer/VideoSettings/BrightnessSlider

# Audio Settings
onready var master_vol_slider = $SettingTabs/Audio/MarginContainer/AudioSettings/MasterVolSlider
onready var music_vol_slider = $SettingTabs/Audio/MarginContainer/AudioSettings/MusicVolSlider
onready var sfx_vol_slider = $SettingTabs/Audio/MarginContainer/AudioSettings/SfxVolSlider

# Gameplay Settings
onready var fov_val = $SettingTabs/Gameplay/MarginContainer/GameSettings/FovHBoxContainer/FovVal
onready var fov_slider = $SettingTabs/Gameplay/MarginContainer/GameSettings/FovHBoxContainer/FovSlider
onready var mouse_sens_val = $SettingTabs/Gameplay/MarginContainer/GameSettings/MouseSensHBoxContainer/MouseSensVal
onready var mouse_sens_slider = $SettingTabs/Gameplay/MarginContainer/GameSettings/MouseSensHBoxContainer/MouseSensSlider


func _ready():
	display_options.select(1 if Save.game_data.fullscreen_on else 0)
	GlobalSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
	vsync_btn.pressed = Save.game_data.vsync_on
	display_fps_btn.pressed = Save.game_data.display_fps
	max_fps_slider.value = Save.game_data.max_fps
	bloom_btn.pressed = Save.game_data.bloom_on
	brightness_slider.value = Save.game_data.brightness
	
	master_vol_slider.value = Save.game_data.master_vol
	#add music and sfx
	
	fov_slider.value = Save.game_data.fov
	mouse_sens_slider.value = Save.game_data.mouse_sens


func _on_DisplayOptionBtn_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func _on_VsyncBtn_toggled(vsync_on):
	GlobalSettings.toggle_vsync(vsync_on)


func _on_DisplayFpsBtn_toggled(fps_display_on):
	GlobalSettings.toggle_fps_display(fps_display_on)


func _on_MaxFpsSlider_value_changed(value):
	GlobalSettings.set_max_fps(value)
	max_fps_val.text = str(value) if value < max_fps_slider.max_value else "max"


func _on_BloomBtn_toggled(bloom_on):
	GlobalSettings.toggle_bloom(bloom_on)


func _on_BrightnessSlider_value_changed(value):
	GlobalSettings.update_brightness(value)


func _on_MasterVolSlider_value_changed(value):
	GlobalSettings.update_master_vol(value)


# warning-ignore:unused_argument
func _on_MusicVolSlider_value_changed(value):
	#GlobalSettings.update_music_vol(1, value)
	pass

#need to implement sfx
# warning-ignore:unused_argument
func _on_SfxVolSlider_value_changed(value):
	#GlobalSettings.update_sfx_vol(2, value)
	pass


func _on_FovSlider_value_changed(value):
	GlobalSettings.update_fov(value)
	fov_val.text = str(value)


func _on_MouseSensSlider_value_changed(value):
	GlobalSettings.update_mouse_sens(value)
	mouse_sens_val.text = str(value)
