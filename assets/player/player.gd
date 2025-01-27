extends CharacterBody2D

@export var SPEED: float = 200

@onready var animation_tree: AnimationTree = $Visuals/AnimationTree
var direction: Vector2 = Vector2.ZERO
var stabbing: bool

func inCutscene() -> bool:
	return stabbing

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
	
	animation_tree["parameters/conditions/idle"] = idle && !inCutscene()
	animation_tree["parameters/conditions/moving"] = moving
	animation_tree["parameters/conditions/stabbing"] = stabbing

func _physics_process(delta: float) -> void:
	if !stabbing:
		direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		self.velocity = SPEED * direction
		
	move_and_slide()

func playStabAnimation():
	stabbing = true
	$Visuals/AnimationPlayer.play("Stab self")
	

func onStabFinished():
	stabbing = false
	$Actor.shouldShowHealthbar = true
	
	var circle = $"Visuals/Stab self/Blood circle" as Sprite2D
	var frame = circle.frame
	circle.reparent(owner, true)
	var newCircle = owner.get_node("Blood circle") as Sprite2D
	newCircle.frame = frame
	newCircle.z_index = 1
	newCircle.visible = true
