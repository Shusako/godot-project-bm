extends Node2D

func doDamage():
	var bodies = $Area2D.get_overlapping_bodies()
	if bodies.size() == 0:
		return
	
	var playerActor = (bodies[0] as Player).get_node("Actor") as Actor
	playerActor.damage(50)
	pass

func animationDone():
	self.call_deferred("queue_free")
