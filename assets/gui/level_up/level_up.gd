extends CanvasLayer

@export var abilityTracker: AbilityTracker

var abilities = [
	{
		"NAME": "BLOOD BULLETS",
		"TYPE": "WEAPON",
		"FRAME": 1,
	},
	#{
		#"NAME": "EXP RANGE",
		#"TYPE": "BUFF",
		#"FRAME": 4,
	#},
	#{
		#"NAME": "BLOOD SPIKES",
		#"TYPE": "WEAPON",
		#"FRAME": 3,
	#}
]

func _ready() -> void:
	$LevelUp.visible = false
	
	var player = get_tree().get_first_node_in_group("player") as Player
	var expCollector = player.actor.get_node("ExpCollector") as ExpCollector
	expCollector.onLevelUp.connect(trigger)
	print("connected")

func trigger(newLevel: int):
	print("level up screen triggered on level: " + str(newLevel))
	get_tree().paused = true
	$LevelUp.visible = true
	
	var availableAbilities = abilities.filter(func(ability): return !abilityTracker.activatedAbilities.has(ability["NAME"]))
	
	var weapons = availableAbilities.filter(func(ability): return ability["TYPE"] == "WEAPON")
	if weapons.size() != 0:
		var option1 = weapons[randi_range(0, weapons.size() - 1)] # weapon only
		availableAbilities = availableAbilities.filter(func(ability): return ability["NAME"] != option1["NAME"])
		
		$"LevelUp/Option 1".visible = true
		$"LevelUp/Option 1/Sprite2D".frame = option1["FRAME"]
		$"LevelUp/Option 1/Label".text = option1["NAME"]
	else:
		# nothing else to pick
		select("magic has won the game!")
	
	var buffs = availableAbilities.filter(func(ability): return ability["TYPE"] == "BUFF")
	if buffs.size() != 0:
		var option2 = buffs[randi_range(0, buffs.size() - 1)] # buff only
		availableAbilities = availableAbilities.filter(func(ability): return ability["NAME"] != option2["NAME"])
		
		$"LevelUp/Option 2".visible = true
		$"LevelUp/Option 2/Sprite2D".frame = option2["FRAME"]
		$"LevelUp/Option 2/Label".text = option2["NAME"]
	else:
		$"LevelUp/Option 2".visible = false
	
	if availableAbilities.size() != 0:
		var option3 = availableAbilities[randi_range(0, availableAbilities.size() - 1)] # any
		availableAbilities = availableAbilities.filter(func(ability): return ability["NAME"] != option3["NAME"])
		
		$"LevelUp/Option 3".visible = true
		$"LevelUp/Option 3/Sprite2D".frame = option3["FRAME"]
		$"LevelUp/Option 3/Label".text = option3["NAME"]
	else:
		$"LevelUp/Option 3".visible = false
	

func _on_option_1_pressed() -> void: select($"LevelUp/Option 1/Label".text)
func _on_option_2_pressed() -> void: select($"LevelUp/Option 2/Label".text)
func _on_option_3_pressed() -> void: select($"LevelUp/Option 3/Label".text)
func select(name: String): 
	print("ability selected: " + name)
	abilityTracker.activatedAbilities.append(name)
	get_tree().paused = false
	$LevelUp.visible = false
