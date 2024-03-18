extends Label


func _process(delta):
	self.text = str(GlobalSettings.score)
	

func _on_Score_body_entered(body):
		if body.is_in_group("score"):
			GlobalSettings.score += 5
		
			$Sfx.stream = load("res://src/sfx/one_shots/Fish_Small_Jump_PSEF.130.wav")
			$Sfx.play()



func _on_ScoreMouth_body_entered(body):
	if body.is_in_group("score"):
			GlobalSettings.score += 5
		
			$Yummy.stream = load("res://src/sfx/one_shots/yummy.wav")
			$Yummy.play()
