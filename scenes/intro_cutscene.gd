extends AnimationPlayer

func _on_animation_started(anim_name: StringName) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($"/root/Bgm", "volume_db", -10, 1)

func _on_animation_finished(anim_name: StringName) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($"/root/Bgm", "volume_db", 0, 1)
