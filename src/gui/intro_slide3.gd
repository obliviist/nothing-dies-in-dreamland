extends Node2D


func _ready():
	$AnimationPlayer.play("intro_fade_in")
	yield(get_tree().create_timer(8), "timeout")
	$AnimationPlayer.play("intro_fade_out")
	yield(get_tree().create_timer(2), "timeout")
	get_tree().change_scene("res://src/gui/intro_slide4.tscn")
