extends Node2D

class_name Actor

@export var team: int = -1
@export var maxHealth: float = 100
@export var shouldShowHealthbar: bool = false

@export var attackDamage: float = 1
@export var attackRange: float = 15
@export var hurtRange: float = 15

@onready var health: float = maxHealth
@onready var hp_bar_background: ColorRect = $HPBarBackground
@onready var hp_bar_health: ColorRect = $HPBarHealth

@onready var attack_area: Area2D = $AttackArea
@onready var attack_circle: CollisionShape2D = $AttackArea/AttackCircle
@onready var hurt_area: Area2D = $HurtArea
@onready var hurt_circle: CollisionShape2D = $HurtArea/HurtCircle

@onready var physicsBody: PhysicsBody2D = get_parent() as PhysicsBody2D

func _ready() -> void:	
	add_to_group("actor")
	
	hp_bar_background.visible = shouldShowHealthbar
	hp_bar_health.visible = shouldShowHealthbar
	
	attack_circle.shape.radius = attackRange
	hurt_circle.shape.radius = hurtRange
	
	if attackRange == 0:
		attack_area.monitoring = false
		attack_area.monitorable = false
	

func damage(amount: float):
	health -= amount
	if health < 0: health = 0
	
	if shouldShowHealthbar:
		hp_bar_health.size.x = (health / maxHealth) * hp_bar_background.size.x
	
	if health <= 0:
		die()
		
func die():
	get_parent().queue_free()

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
	
