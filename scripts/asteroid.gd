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
	queue_free()
	if radius <= 6:
		GameState.decrease_asteroid_count()
		return
	print("split")
	get_tree().root.get_child(1).spawn_child_asteroids(position, radius/2)

func set_size(radius : int):
	self.radius = radius
	$CollisionShape3D.shape.radius = radius
	$MeshInstance3D.mesh.radius = radius
	$MeshInstance3D.mesh.height = 2 * radius
	$MeshInstance3D2.mesh.radius = radius
	$MeshInstance3D2.mesh.height = 2 * radius
	$Hitbox/CollisionShape3D.shape.radius = radius + 1
	mass = 100 * radius / 24

#func _on_mesh_instance_3d_tree_exited() -> void:
	#if radius == 3:
		#GameState.decrease_asteroid_count()
		#return
	#await(self.ready)
	#print("split")
	#get_tree().root.get_child(1).spawn_child_asteroids(position, radius/2)

#
#func _on_hitbox_body_entered(body: RigidBody3D) -> void:
	#print("boom?")
	#if body.is_in_group("Projectile"):
		#print("boom")
		#body.queue_free()
		#split()
