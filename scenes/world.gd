extends Node

@onready var background_layer: TileMapLayer = $BackgroundLayer
@onready var player: CharacterBody2D = $"../Player"

func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var viewport = get_viewport()
	var camera = viewport.get_camera_2d()
	
	var screenSize = viewport.get_visible_rect().size
	var topLeft = background_layer.local_to_map(Vector2i(camera.global_position) - Vector2i(screenSize / 2))
	var topRight = background_layer.local_to_map(Vector2i(camera.global_position) + Vector2i(screenSize / 2))
	
	for i in range(topLeft.x, topRight.x + 1):
		for j in range(topLeft.y, topRight.y + 1):
			var position = Vector2i(i, j)
			if background_layer.get_cell_source_id(position) == -1:
				background_layer.set_cell(position, 0, Vector2i(0, 0), 0)
	


func _on_intro_cutscene_animation_started(anim_name: StringName) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($"/root/Bgm", "volume_db", -10, 1)

func _on_intro_cutscene_animation_finished(anim_name: StringName) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($"/root/Bgm", "volume_db", 0, 1)
