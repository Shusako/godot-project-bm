extends Node

const BLOOD_BULLET = preload("res://assets/abilities/blood_bullet/blood_bullet.tscn")

@export var nearbyArea: Area2D

var bloodBulletCooldown = 10
var bloodBulletCounter = bloodBulletCooldown
var bloodBulletSpeed = 125

func _ready():
	self.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	var player = (get_tree().get_nodes_in_group("player") as Array[RigidBody2D])[0]
	
	var enemies = (nearbyArea.get_overlapping_bodies() as Array[RigidBody2D]).filter(
		func(node): 
			return node.has_node("Actor") && node != player
	)

	if enemies.size() == 0:
		return
	
	#enemies.sort_custom(
		#func(enemy1):
			#return enemy1.distance_to(player)
	#)
	
	enemies.sort_custom(
		func(enemy1, enemy2):
			return enemy1.global_position.distance_to(player.global_position) < enemy2.global_position.distance_to(player.global_position)
	)
	
	var closestEnemy = enemies[0] as Node2D
	
	# Check blood bullet
	bloodBulletCounter -= 1
	if bloodBulletCounter <= 0:
		var bullet = BLOOD_BULLET.instantiate()
		bullet.global_position = player.global_position
		bullet.linear_velocity = (closestEnemy.global_position - bullet.global_position).normalized() * bloodBulletSpeed
		bullet.rotation = bullet.linear_velocity.angle()
		get_tree().root.add_child(bullet)
		
		bloodBulletCounter = bloodBulletCooldown
	pass
