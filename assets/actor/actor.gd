extends Node2D

class_name Actor

@export var team: int = -1
@export var maxHealth: float = 100

@export var shouldShowBars: bool = false
@export var expAmount: int = 1
var level: int = 1
var expToNextLevel: float = 0
var currentExp: float = 0

@export var attackDamage: float = 1
@export var attackRange: float = 15
@export var hurtRange: float = 15

@onready var health: float = maxHealth
@onready var hp_bar_background: ColorRect = $HPBarBackground
@onready var hp_bar_health: ColorRect = $HPBarHealth
@onready var exp_bar: ColorRect = $ExpBar
@onready var maxBarWidth: float = hp_bar_health.size.x

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
	
	updateBarSize()
	calcExpToNextLevel()

func updateBarSize():
	if !shouldShowBars:
		return
	
	exp_bar.size.x = (currentExp / expToNextLevel) * maxBarWidth
	hp_bar_health.size.x = (health / maxHealth) * maxBarWidth
	

func calcExpToNextLevel():
	expToNextLevel = pow(level, 0.8) * 10

func gainExp(amount: float):
	currentExp += amount
	
	if currentExp > expToNextLevel:
		currentExp -= expToNextLevel
		level += 1
		calcExpToNextLevel()
		
		print ("Now level " + str(level) + ", need for next level: " + str(expToNextLevel))
	
	updateBarSize()
	
	pass

func damage(amount: float):
	health -= amount
	if health < 0: health = 0
	
	updateBarSize()
	
	if health <= 0:
		die()
		
func die():
	# drop exp
	for i in range(expAmount):
		var expNode = EXP_ORB.instantiate()
		var angle = randf() * 2 * PI
		# small random offset
		expNode.global_position = self.global_position + Vector2(cos(angle), sin(angle))
		get_tree().root.add_child(expNode)
	
	get_parent().queue_free()

func _process(delta: float) -> void:
	hp_bar_background.visible = shouldShowBars
	hp_bar_health.visible = shouldShowBars
	exp_bar.visible = shouldShowBars

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
	
