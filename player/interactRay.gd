extends RayCast

onready var prompt = $Prompt

func _ready():
	add_exception(owner)
	
func _physics_process(_delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable:
			prompt.text = detected.name
