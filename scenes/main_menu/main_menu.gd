extends Control

const FIRST_LEVEL = preload("res://scenes/first_level.tscn")
const TEST_WORLD_LEVEL = preload("res://scenes/test.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(FIRST_LEVEL)

func _on_test_world_button_pressed() -> void:
	print("loading test")
	get_tree().change_scene_to_packed(TEST_WORLD_LEVEL)
