extends RigidBody2D

@export var speed: float = 10
@export var damage: float = 100

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	var actor = body.find_child("Actor") as Actor
	if actor != null:
		actor.damage(damage)
		self.queue_free()
