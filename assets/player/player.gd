extends CharacterBody2D

@export var SPEED: float = 200

var allowMovement: bool

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if allowMovement:
		self.velocity = SPEED * Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
	move_and_slide()

func playStabAnimation():
	allowMovement = false
	$Visuals/AnimationPlayer.play("Stab self")
	

func onStabFinished():
	allowMovement = true
	$Actor.shouldShowHealthbar = true
	
	var circle = $"Visuals/Spawn/Blood circle" as Sprite2D
	var frame = circle.frame
	circle.reparent(owner, true)
	var newCircle = owner.get_node("Blood circle") as Sprite2D
	newCircle.frame = frame
	newCircle.z_index = 1
