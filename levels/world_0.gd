extends Spatial

onready var world_env = $Environment/WorldEnvironment

func _ready():
	world_env.environment.dof_blur_far_enabled = false
	world_env.environment.dof_blur_near_enabled = false

