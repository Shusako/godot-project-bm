extends Node2D

@export var enableHealthBar: bool = false
@export var enableExpBar: bool = false

@onready var hp_bar_background: ColorRect = $HPBarBackground
@onready var hp_bar_health: ColorRect = $HPBarHealth
@onready var exp_bar: ColorRect = $ExpBar

@onready var maxBarWidth: float = hp_bar_health.size.x
@onready var maxBarHeight: float = hp_bar_health.size.y
@onready var barStartingY: float = hp_bar_health.position.y

func _ready() -> void:
	var enabledBars: Array[ColorRect]
	
	if enableHealthBar:
		var actor: Actor = get_parent() as Actor
		actor.onDamaged.connect(updateHealth)
		enabledBars.append(hp_bar_health)
	else:
		hp_bar_health.visible = false
	
	if enableExpBar:
		var expCollector = get_node("../ExpCollector") as ExpCollector
		expCollector.onExpGain.connect(updateExp)
		enabledBars.append(exp_bar)
	else:
		exp_bar.visible = false
	
	var enabledBarCount = enabledBars.size()
	if enabledBarCount == 0:
		hp_bar_background.visible = false
	
	var allowedHeight = maxBarHeight / enabledBarCount
	
	for i in enabledBars.size():
		var bar = enabledBars[i]
		bar.position.y = barStartingY + allowedHeight * i
		bar.size.y = allowedHeight
	
	pass

func updateHealth(amount: float, currentHealth: float, maxHealth: float):
	hp_bar_health.size.x = (currentHealth / maxHealth) * maxBarWidth
	pass

func updateExp(amount: float, currentExp: float, expToNextLevel: float):
	exp_bar.size.x = (currentExp / expToNextLevel) * maxBarWidth
	pass

func setBarVisibility(flag: bool):
	self.visible = flag
	pass
