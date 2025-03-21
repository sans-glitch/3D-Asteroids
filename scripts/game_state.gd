extends Node
var difficulty
var score
var num_asteroids

func _ready() -> void:
	difficulty = 0
	score = 0
	
func _process(delta: float) -> void:
	if num_asteroids <= 0:
		increase_difficulty(5)
		get_tree().call_group("Game", "respawn_asteroids")

func set_asteroids_num(num : int):
	num_asteroids = num
	difficulty = max(num, difficulty)

func decrease_asteroid_count():
	num_asteroids -= 1
	#score += 1
func increase_asteroid_count(amount : int):
	num_asteroids += amount

func increase_difficulty(amount : int):
	difficulty += amount
	
func reset(start_difficulty : int):
	score = 0
	difficulty = start_difficulty
func increase_score(amount : int):
	score += amount
