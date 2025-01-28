extends Resource

class_name spawnable_enemy

@export var scene: PackedScene
@export_range(0.0, 30.0) var earliestSpawnTime: float = 0.0
@export_range(0.0, 1.0) var rarity: float = 0.0
