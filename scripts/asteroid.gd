extends RigidBody3D

var is_visible = false
var velocity = randi_range(10, 15)
var radius = 24

@export var direction = Vector3(1, 0, 0)
var center : Vector3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center = $"../Ship".position
	contact_monitor = true
	set_size(radius)
	linear_velocity = velocity * direction
	rotate(Vector3(1, 0, 0), randf_range(-PI, PI))
	apply_torque(Vector3(randf_range(-1, 1),randf_range(-1, 1),randf_range(-1, 1)).normalized() * 100000)

func set_direction(dir : Vector3):
	direction = dir

func set_center(center : Vector3):
	self.center = center

func randomize_direction():
	direction = Vector3(randf()-0.5, randf()-0.5, randf()-0.5).normalized()

func _physics_process(delta: float) -> void:
	#apply_central_force(velocity * direction * 100)
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	pass
	# Resets the asteroids location closer to the ship if not in view
	if not is_visible:
		center = $"../Ship".position
		position.x = fmod(position.x - center.x + 100, 200.0) - 100 + center.x
		position.y = fmod(position.y - center.y + 100, 200.0) - 100 + center.y
		position.z = fmod(position.z - center.z + 100, 200.0) - 100 + center.z

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Detecting projectile hit
	var bodies = $Hitbox.get_overlapping_areas()
	for body in bodies:
		if body.is_in_group("Projectile"):
			body.queue_free()
			split()
			break

func _on_visible_on_screen_notifier_3d_screen_entered() -> void:
	is_visible = true


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	is_visible = false

func split():
	AudioManager.play("res://assets/sounds/explosion.wav")
	GameState.increase_score(get_hit_score())
	queue_free()
	if radius <= 6:
		GameState.decrease_asteroid_count()
		
		return
	get_tree().root.get_child(2).spawn_child_asteroids(position, radius/2)

func set_size(radius : int):
	self.radius = radius
	$CollisionShape3D.shape.radius = radius
	$BlackMesh.mesh.radius = radius
	$BlackMesh.mesh.height = 2 * radius
	#$BlackMesh.mesh.radial_segments = 20 * (radius/24)
	#$BlackMesh.mesh.rings = 12 * (radius/24)
	$OutlineMesh.mesh.radius = radius
	$OutlineMesh.mesh.height = 2 * radius
	#$OutlineMesh.mesh.radial_segments = 20 * (radius/24)
	#$OutlineMesh.mesh.rings = 12 * (radius/24)
	$Hitbox/CollisionShape3D.shape.radius = radius + 1
	$VisibleOnScreenNotifier3D.aabb = AABB(Vector3(-radius, -radius, -radius), Vector3(radius* 2, radius*2, radius*2))
	mass = 100 * radius / 24

func get_hit_score():
	if radius == 24:
		return 20
	elif radius == 12:
		return 50
	return 100

#func create_asteroid(num_vertices : int):
	#var a_mesh : ArrayMesh
	#var vertices := PackedVector3Array(
		#
	#)
	#for i in num_vertices:
		#vertecies.append(Vector3(randf_range(-1, 10), randf_range(-1, 10), randf_range(-1, 10)).normalized())
	#var mesh : MeshInstance3D
	#Geometry3D.get_triangle_barycentric_coords()
	#
