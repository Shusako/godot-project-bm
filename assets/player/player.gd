extends CharacterBody2D

class_name Player

@onready var actor: Actor = get_node("Actor") as Actor

@export var SPEED: float = 5

@onready var animation_tree: AnimationTree = $Visuals/AnimationTree
var direction: Vector2 = Vector2.ZERO

var inCutscene: bool
var stabbing: bool

func _ready() -> void:
	actor.health = actor.maxHealth / 10
	actor.damage(-1)

func _process(delta: float) -> void:	
	updateAnimationTree()

func updateAnimationTree():
	var idle: bool
	var moving: bool
	
	if self.velocity == Vector2.ZERO:
		idle = true
		moving = false
	else:
		animation_tree["parameters/idle/blend_position"] = direction.x
		animation_tree["parameters/walk/blend_position"] = direction.x
		idle = false
		moving = true
	
	animation_tree["parameters/conditions/idle"] = idle && !inCutscene
	animation_tree["parameters/conditions/moving"] = moving
	animation_tree["parameters/conditions/stabbing"] = stabbing

func _physics_process(delta: float) -> void:
	if !inCutscene:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		self.velocity = SPEED * direction
		
	move_and_slide()

func playStabAnimation():
	stabbing = true
	$Visuals/AnimationPlayer.play("Stab self")

func setInCutscene(flag: bool):
	$Actor/Bars.setBarVisibility(!flag)
	inCutscene = flag

func onStabFinished():
	stabbing = false
	
	var circle = $"Visuals/Stab self/Blood circle" as Sprite2D
	var frame = circle.frame
	
	circle = circle.duplicate()
	get_tree().root.add_child(circle)
	
	var newCircle = get_tree().root.get_node("Blood circle") as Sprite2D
	newCircle.frame = frame
	newCircle.z_index = 1
	newCircle.visible = true
