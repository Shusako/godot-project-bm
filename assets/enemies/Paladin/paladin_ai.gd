extends Node

@onready var actor: Actor = get_parent() as Actor
@export var speed: float = 20
@export var keepDistance: float = 100

@onready var animation_player: AnimationPlayer = $"../../Visuals/AnimationPlayer"
const HOLY_LIGHT = preload("res://assets/abilities/holy_light/holy_light.tscn")

var abilityRange: float = keepDistance + 30
var abilityUsable: bool = true
var abilityCooldown: float = 3.0

var inCastAnimation: bool = false

func useAbility():
	abilityUsable = false
	
	inCastAnimation = true
	animation_player.play("casting")
	await animation_player.animation_finished
	inCastAnimation = false
	
	await get_tree().create_timer(abilityCooldown).timeout
	abilityUsable = true

func spawnHolyLight():
	# find player and spawn attack on them
	var player = get_tree().get_first_node_in_group("player")
	var spawnPosition = player.global_position + player.velocity * 0.5
	
	var holyLightNode = HOLY_LIGHT.instantiate()
	holyLightNode.global_position = spawnPosition
	get_tree().root.add_child(holyLightNode)

func _physics_process(delta: float) -> void:
	actor.physicsBody.angular_velocity = 0
	actor.physicsBody.rotation = 0
	
	# move towards player
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	var distance = (actor.physicsBody.global_position.distance_to(player.global_position))
	var moveModifier = 0
	if abs(distance - keepDistance) > 20:
		moveModifier = sign(distance - keepDistance)
	
	var velocityTowardsPlayer: Vector2 = (player.global_position - actor.physicsBody.global_position).normalized() * speed
	actor.physicsBody.linear_velocity = velocityTowardsPlayer * moveModifier
	
	if distance < abilityRange and abilityUsable:
		print("using ability")
		useAbility()
	
	if inCastAnimation:
		actor.physicsBody.linear_velocity = Vector2.ZERO
	else:
		if actor.physicsBody.linear_velocity == Vector2.ZERO:
			animation_player.play("stand")
		else:
			animation_player.play("walk")
