extends Node

@onready var background_layer: TileMapLayer = $BackgroundLayer
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	pass

var backgroundOptions: Array = [
	{
		weight = 100.0,
		size = 1,
		place = func(pos): basicPlace(pos, 0, 0, Vector2(0, 0)),
	},
	{
		weight = 100.0,
		size = 1,
		place = func(pos): basicPlace(pos, 0, 0, Vector2(0, 1)),
	},
	{
		weight = 1.0,
		size = 1,
		place = func(pos): basicPlace(pos, 0, 0, Vector2(1, 1)),
	},
	{
		weight = 0.05,
		size = 1,
		place = func(pos): basicPlace(pos, 0, 0, Vector2(2, 1)),
	},
	{
		weight = 0.05,
		size = 1,
		place = func(pos): basicPlace(pos, 0, 0, Vector2(3, 1)),
	},
	{
		weight = 0.1,
		size = 2,
		place = func(pos):
			basicPlace(pos, 0, 0, Vector2(0, 2))
			basicPlace(pos + Vector2(1, 0), 0, 0, Vector2(1, 2))
			basicPlace(pos + Vector2(0, 1), 0, 0, Vector2(0, 3))
			basicPlace(pos + Vector2(1, 1), 0, 0, Vector2(1, 3)),
	}
]

var totalBackgroundOptionsWeight: float = backgroundOptions.reduce(func(acc, option):
	return (acc + option.weight), 0.0)
	
var maxBackgroundSize: int = backgroundOptions.reduce(func(acc, option): return max(acc, option.size), 0)

func basicPlace(position, sourceId, alternativeId, coords):
	background_layer.set_cell(position, sourceId, coords, alternativeId)	

func pickRandomBackgroundOption():
	# potentially change this with a noise-like weight picker
	var weightPicker = randf_range(0.0, totalBackgroundOptionsWeight)
	for option in backgroundOptions:
		weightPicker -= option.weight
		if weightPicker < 0.0:
			return option

func populateRandomBackgroundTile(position: Vector2):
	var option = pickRandomBackgroundOption()
	option.place.call(position)

func _physics_process(delta: float) -> void:
	var viewport = get_viewport()
	var camera = viewport.get_camera_2d()
	
	var screenSize = viewport.get_visible_rect().size
	var topLeft = background_layer.local_to_map(Vector2i(camera.global_position) - Vector2i(screenSize / 2)) - Vector2i(maxBackgroundSize, maxBackgroundSize)
	var bottomRight = background_layer.local_to_map(Vector2i(camera.global_position) + Vector2i(screenSize / 2)) + Vector2i(maxBackgroundSize, maxBackgroundSize)
	
	for i in range(topLeft.x, bottomRight.x + 1):
		for j in range(topLeft.y, bottomRight.y + 1):
			var position = Vector2i(i, j)
			if background_layer.get_cell_source_id(position) == -1:
				populateRandomBackgroundTile(position)
	

func _on_intro_cutscene_animation_started(anim_name: StringName) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(Bgm, "volume_db", -13, 1.5)

func _on_intro_cutscene_animation_finished(anim_name: StringName) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(Bgm, "volume_db", 0, 1.5)
