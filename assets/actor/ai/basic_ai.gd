extends Node

@onready var actor: Actor = get_parent() as Actor
@export var speed: float = 15

func _physics_process(delta: float) -> void:
	actor.physicsBody.angular_velocity = 0
	actor.physicsBody.rotation = 0
	
	# move towards player
	var player = get_tree().get_first_node_in_group("player") # if do many players, then pick based on some metric, not first
	if player:
		var velocityTowardsPlayer: Vector2 = (player.global_position - actor.physicsBody.global_position).normalized() * speed
		actor.physicsBody.linear_velocity = velocityTowardsPlayer
	pass
