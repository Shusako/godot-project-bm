extends Timer

@export var spawnableEnemies: Array[spawnable_enemy] = []

@onready var startTimestamp = Time.get_ticks_msec()
@export var spawnRadius: float = 30 * 16

func _ready() -> void:
	self.timeout.connect(onTick)

func getEnemy(currentTime: float) -> spawnable_enemy:
	var pickList = spawnableEnemies.filter(
		func(enemy):
			return currentTime > enemy.earliestSpawnTime
	)
	
	# TODO: do something with .rarity
	var rand = randi_range(0, pickList.size() - 1)
	return pickList[rand]

func onTick():
	var levelTimeMinutes = ((Time.get_ticks_msec() - startTimestamp) / 1000.0) / 60.0
	
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		var numberToSpawn = randi_range(3, 5)
		for i in range(numberToSpawn):
			var enemy = getEnemy(levelTimeMinutes)
			
			var enemyNode = enemy.scene.instantiate()
			var angle = randf() * 2 * PI
			# small random offset
			enemyNode.global_position = player.global_position + Vector2(cos(angle), sin(angle)) * spawnRadius
			get_tree().root.add_child(enemyNode)
		
	
