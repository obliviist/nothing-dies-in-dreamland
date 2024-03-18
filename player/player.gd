extends KinematicBody

export var max_speed = 12
export var acceleration = 60
export var friction = 50
export var air_friction = 10
export var jump_impulse = 20
export var gravity = -40

export var mouse_sensitivity = 0.1
export var controller_sensitivity = 3

export (int, 0, 10) var push = 1

var velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO

onready var head = $Head
onready var interaction = $Head/Camera/Interaction
onready var hand = $Head/Camera/Hand
onready var joint = $Head/Camera/Generic6DOFJoint
onready var staticbody = $Head/Camera/StaticBody
onready var camera =$Head/Camera

var picked_object
var pull_power = 4
var rotation_power = 0.05
var locked = false

func _ready():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalSettings.connect("fov_updated", self, "_on_fov_updated")
	GlobalSettings.connect("mouse_sens_updated", self, "_on_mouse_sens_updated")
	global_transform.origin = Vector3(1, 150, 72)
	#i love thee above line of code sosososoosososososososososososo much
	
func _capture_screen():
	var vpt: Viewport = get_viewport()
	var tex: Texture = vpt.get_texture()
	var img: Image = tex.get_data()
	img.flip_y()
	img.save_png("res://user/screenshot.png")
	
func _unhandled_input(event):
	if event.is_action_pressed("lclick"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event.is_action_pressed("toggle_mouse_mode"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))

		
func pick_object():
	var collider = interaction.get_collider()
	if collider != null and collider is RigidBody:
		picked_object = collider
		joint.set_node_b(picked_object.get_path())
		
func remove_object():
	if picked_object != null:
		picked_object = null
		joint.set_node_b(joint.get_path())
		
func _input(event):
	
	if Input.is_action_just_pressed("lclick"):
		if picked_object == null:
			pick_object()
		elif picked_object != null:
			remove_object()
	
	if Input.is_action_just_pressed("throw"):
		if picked_object != null:
			var knockback = picked_object.translation - translation
			picked_object.apply_central_impulse(knockback * 5)
			remove_object()
			
	if Input.is_action_just_pressed("capture_screen"):
		_capture_screen()
	
func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(direction, delta)
	apply_friction(direction, delta)
	apply_gravity(delta)
	jump()
	apply_controller_rotation()
	head.rotation.x = clamp(head.rotation.x, deg2rad(-75), deg2rad(75))
	velocity = move_and_slide_with_snap(velocity, snap_vector, Vector3.UP, true, 4, .785398, false)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	for idx in get_slide_count():
		var collision = get_slide_collision(idx)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * velocity.length() * push)
	
	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a)*pull_power)
	
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	
	
func get_direction(input_vector):
	var direction = Vector3.ZERO
	direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction
	
func apply_movement(direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * max_speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * max_speed, acceleration * delta).z
		
		
func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)
		else:
			velocity.x = velocity.move_toward(Vector3.ZERO, air_friction * delta).x
			velocity.z = velocity.move_toward(Vector3.ZERO, air_friction * delta).z
			
			
func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)
	
	
func update_snap_vector():
	snap_vector = -get_floor_normal() if is_on_floor() else Vector3.DOWN
	
	
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		snap_vector = Vector3.ZERO
		velocity.y = jump_impulse
	if Input.is_action_just_released("jump") and velocity.y > jump_impulse / 2:
		velocity.y = jump_impulse / 2


func apply_controller_rotation():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("look_right") - Input.get_action_strength("look_left")
	axis_vector.y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	
	if InputEventJoypadMotion:
		rotate_y(deg2rad(-axis_vector.x) * controller_sensitivity)
		head.rotate_x(deg2rad(-axis_vector.y) * controller_sensitivity)

func _on_Death_body_entered(body):
	if body.is_in_group("player"):
		SimpleSave.save_scene(get_tree(), "res://save_slots/save_continue.tscn")
		get_tree().change_scene("res://src/gui/continue_menu.tscn")
		
func _on_fov_updated(value):
	camera.fov = value

func _on_mouse_sens_updated(value):
	mouse_sensitivity = value
