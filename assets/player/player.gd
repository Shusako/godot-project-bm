extends CharacterBody2D

@export var SPEED: float = 200

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	self.velocity = SPEED * Input.get_vector("move_left", "move_right", "move_up", "move_down")
	move_and_slide()
