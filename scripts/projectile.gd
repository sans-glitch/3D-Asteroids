extends RigidBody3D

@export var speed = 500
var deactivated = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play("res://assets/sounds/laserShoot.wav")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_and_collide(-transform.basis.z * speed * delta)
#
#func _on_area_3d_body_entered(body: RigidBody3D) -> void:
	#if body.is_in_group("Asteroid") and not deactivated:
		#deactivated = true
		#self.queue_free()
		#body.split()
		##GameState.decrease_asteroid_count()
		#

func _on_timer_timeout() -> void:
	queue_free()
