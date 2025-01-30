extends Node2D

class_name ExpCollector

signal onExpGain(amount: float, currentExp: float, expToNextLevel: float)
signal onLevelUp(newLevel: int)

var level: int = 1
var expToLevelExponent: float = 0.8
var expToLevelScale: float = 10.0
var currentExp: float = 0
var expToNextLevel: float = 0

@export var collectionRange: float = 50
var absorbRange: float = 8
var expSpeed: float = 80
@onready var collector: Actor = get_parent() as Actor

func _ready() -> void:
	calcExpToNextLevel()

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
			gainExp(1)
			exp_node.queue_free()
			pass
		pass
	pass

func calcExpToNextLevel():
	expToNextLevel = pow(level, 0.8) * 10

func gainExp(amount: float):
	currentExp += amount
	
	# while because we could get a massive amount of Exp at once
	while currentExp > expToNextLevel:
		currentExp -= expToNextLevel
		level += 1
		calcExpToNextLevel()
		
		emit_signal("onLevelUp", level)
		print ("Now level " + str(level) + ", need for next level: " + str(expToNextLevel))
	
	emit_signal("onExpGain", amount, currentExp, expToNextLevel)	
	pass
