class_name Interactable
extends RigidBody

signal interacted(body)

export var prompt_message = "Interact"
export var prompt_action = "interact"

var direction = Vector3.FORWARD

func get_prompt():
	var key_name = ""
	for action in InputMap.get_action_list(prompt_action):
		if action is InputEventKey:
			key_name = OS.get_scancode_string(action.scancode)
	return prompt_message + "\n[" + key_name + "]"

func interact(body):
	emit_signal("interacted", body)
	
