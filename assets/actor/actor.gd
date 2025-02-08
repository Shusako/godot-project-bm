extends Node2D

class_name Actor

@export var maxHealth: float = 100
@onready var health: float = maxHealth
signal onDamaged(amount: float, currentHealth: float, maxHealth: float)

@export var team: int = -1
@export var expWorth: int = 1

@export var attackDamage: float = 1
@export var attackRange: float = 15
@export var hurtRange: float = 15

@onready var attack_area: Area2D = $AttackArea
@onready var attack_circle: CollisionShape2D = $AttackArea/AttackCircle
@onready var hurt_area: Area2D = $HurtArea
@onready var hurt_circle: CollisionShape2D = $HurtArea/HurtCircle

@onready var physicsBody: PhysicsBody2D = get_parent() as PhysicsBody2D

const EXP_ORB = preload("res://assets/items/exp_orb/exp_orb.tscn")

func _ready() -> void:
	attack_circle.shape.radius = attackRange
	hurt_circle.shape.radius = hurtRange
	
	if attackRange == 0:
		attack_area.monitoring = false
		attack_area.monitorable = false

# We accept negative damage
func damage(amount: float):	
	health -= amount
	if health < 0: health = 0
	if health > maxHealth: health = maxHealth
	
	emit_signal("onDamaged", amount, health, maxHealth)
	
	if health == 0:
		die()

func die():
	# drop exp
	for i in range(expWorth):
		var expNode = EXP_ORB.instantiate()
		var angle = randf() * 2 * PI
		# small random offset
		expNode.global_position = self.global_position + Vector2(cos(angle), sin(angle))
		expNode.linear_velocity = Vector2(cos(angle), sin(angle))
		get_tree().root.call_deferred("add_child", expNode)
	
	get_parent().call_deferred("queue_free")

func _physics_process(delta: float) -> void:	
	if attackRange != 0:
		var hurtBoxes = attack_area.get_overlapping_areas()
		var selfIndex = hurtBoxes.find(hurt_area)
		if selfIndex != -1:
			hurtBoxes.remove_at(selfIndex) # remove our own hurtbox
		
		for hurtBox in hurtBoxes:
			var actor = hurtBox.get_parent() as Actor
			if actor.team != self.team:
				actor.damage(attackDamage)
	
