extends Node3D

@onready var timer: Timer = $Timer
@export var asteroid : PackedScene
@onready var ship: Area3D = $Ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$WorldEnvironment.set_bg_energy_multiplier(0)
	timer.wait_time = 1
	GameState.set_asteroids_num(5)
	respawn_asteroids()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	pass


func _on_timer_timeout() -> void:
	#spawn_asteroid()
	pass

func spawn_asteroid():
	var tmp_asteroid = asteroid.instantiate()
	var center = ship.position
	#tmp_asteroid.set_center(center)
	tmp_asteroid.position = Vector3(randi_range(center.x-100, center.x+100), randi_range(center.y-100, center.y+100), randi_range(center.z-100, center.z+100))
	tmp_asteroid.randomize_direction()
	add_child(tmp_asteroid)

func respawn_asteroids():
	GameState.set_asteroids_num(GameState.difficulty)
	for i in GameState.difficulty:
		spawn_asteroid()

func spawn_child_asteroids(position : Vector3, new_size : int):
	var ast1 = asteroid.instantiate()
	var ast2 = asteroid.instantiate()
	ast1.set_size(new_size)
	ast2.set_size(new_size)
	var offset = Vector3(randf_range(-1, 1),randf_range(-1, 1),randf_range(-1, 1)).normalized()
	ast1.position = position + offset * (new_size)
	ast2.position = position - offset * (new_size)
	ast1.direction = offset
	ast2.direction = -offset
	#ast1.apply_force(offset * 3, position)
	#ast2.apply_force(-offset * 3, position)
	ast1.velocity *= 24/new_size
	ast2.velocity *= 24/new_size
	add_child(ast1)
	add_child(ast2)
	GameState.increase_asteroid_count(1)
	pass
