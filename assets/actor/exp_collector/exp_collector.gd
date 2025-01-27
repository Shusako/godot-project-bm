extends Node2D

@export var collectionRange: float = 50
var absorbRange: float = 8
var expSpeed: float = 80
@onready var collector: Actor = get_parent() as Actor

func _physics_process(delta: float) -> void:
	var collectorPosition = collector.global_position
	
	var nearbyExp = get_tree().get_nodes_in_group("exp").filter(
		func(exp_node):
			return exp_node.global_position.distance_to(collectorPosition) < collectionRange
	)
	
	for exp_node in nearbyExp:
		var vectorToPlayer = (collectorPosition - exp_node.global_position).normalized()
		
		var notTowardsPlayer = (exp_node.position + exp_node.linear_velocity) - collectorPosition
		exp_node.linear_velocity -= notTowardsPlayer
		
		exp_node.linear_velocity += vectorToPlayer * expSpeed
		
		if exp_node.global_position.distance_to(collectorPosition) < absorbRange:
			collector.gainExp(1)
			exp_node.queue_free()
			pass
		pass
	pass
