extends Area3D

var velocity : Vector3
var acceleration = 5
var previous_mouse_pos = Vector2.ZERO
var pitch = 0
var roll = 0
@export var projectile : PackedScene
@export var mouse_controls : bool = true
var health
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 3
	$"..".starting.connect(_on_start.bind())
	pass # Replace with function body.

func _on_start():
	$IFrames.start()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		rotate_object_local(Vector3(0, 0, 1), 1* delta)
	if Input.is_action_pressed("ui_right"):
		rotate_object_local(Vector3(0, 0, 1), -1 * delta)
	if Input.is_action_pressed("ui_up"):
		rotate_object_local(Vector3(1, 0, 0), -1* delta)
	if Input.is_action_pressed("ui_down"):
		rotate_object_local(Vector3(1, 0, 0), 1 * delta)
	var current_mouse_pos = get_viewport().get_mouse_position()
	var mouse_delta = current_mouse_pos - previous_mouse_pos
	previous_mouse_pos = current_mouse_pos
	var pitch_sensitivity = 0.01
	var roll_sensitivity = 0.01
	#apply_torque(Vector3(-mouse_delta.y * 100, 0, -mouse_delta.x * 100))
	#if mouse_delta.length() > 1:
		#pitch += 
	#rotate_object_local(Vector3(1, 0, 0))
	##rotation.x += mouse_delta.y * pitch_sensitivity  * delta 
	#rotate_y(Vector3(1, 0, 0), mouse_delta.y * pitch_sensitivity * delta )
	## Apply pitch rotation based on mouse Y movement
	## Apply roll rotation based on mouse X movement
	#rotate_object_local(Vector3(1, 0, 0), 1 * 0.005) # Pitch
	#rotate_object_local(Vector3(0, 0, 1), 1 * 0.001) # Roll
	#rotate_object_local(Vector3(1, 0, 0), mouse_delta.y * pitch_sensitivity)
	#rotate_object_local(Vector3(0, 0, 1), mouse_delta.x * roll_sensitivity)
	#translate_local(Transform3D.IDENTITY.rotated(Vector3(0, 0, 1), mouse_delta.y * pitch_sensitivity))
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Asteroid"):
			crash(body)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_left"):
		rotate_object_local(Vector3(0, 0, 1), 1 * 0.001)
	if Input.is_action_pressed("ui_right"):
		rotate_object_local(Vector3(0, 0, 1), -1 * 0.001)
	if Input.is_action_pressed("ui_up"):
		rotate_object_local(Vector3(1, 0, 0), -1 * 0.01)
	if Input.is_action_pressed("ui_down"):
		rotate_object_local(Vector3(1, 0, 0), 1 * 0.01)
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion and mouse_controls:
			#apply_torque(Vector3(-event.relative.y * 100, 0, -event.relative.x * 100))
			rotate_object_local(Vector3(1, 0, 0), -event.relative.y * 0.01)
			rotate_object_local(Vector3(0, 0, 1), -event.relative.x * 0.01)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health < 1:
		AudioManager.play("res://assets/sounds/explosion.wav")
		GameState.reset(5)
		get_tree().reload_current_scene()
	var input_dir := Vector3.ZERO
	if Input.is_action_pressed("accelerate"):
		input_dir = Vector3(0, -1, 0)
	if Input.is_action_pressed("back"):
		velocity = velocity - velocity * 0.05
	if Input.is_action_pressed("shoot"):
		shoot()
	#if Input.is_action_pressed("shoot"):
		#shoot()
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity += direction * acceleration
	velocity = velocity - velocity * 0.01
	position += velocity * delta
	
	
func shoot():
	if not $ShootTimer.is_stopped():
		return
	var tmp_projectile = projectile.instantiate()
	tmp_projectile.linear_velocity = velocity
	tmp_projectile.position = self.position
	tmp_projectile.rotation = self.rotation
	add_sibling(tmp_projectile)
	$ShootTimer.start()
	
func crash(asteroid : Node3D):
	var bump = (global_position - asteroid.global_position).normalized() * 50
	velocity = bump
	asteroid.split()
	if $IFrames.time_left > 0:
		return
	AudioManager.play("res://assets/sounds/hit.wav")
	health -= 1
	$IFrames.start()
	#position += bump
	
