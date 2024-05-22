extends Area2D
signal health_collected
signal copilot_collected
signal coin_collected
signal time_collected

enum Bonuses { HEALTH, TIME, COIN, COPILOT}
@export var bonus_type:Bonuses


#65, 15, 15, 5
func _ready():
	var chance = randf_range(0, 1)
	if chance <= 0.1:
		bonus_type = Bonuses.COPILOT
		$AnimationPlayer.play("copilot")
	elif 0.1 < chance and chance <= 0.3:
		bonus_type = Bonuses.HEALTH
		$AnimationPlayer.play("health")
	elif 0.3 < chance and chance <= 0.6:
			bonus_type = Bonuses.TIME
			$AnimationPlayer.play("time")
	else:
		bonus_type = Bonuses.COIN
		$AnimationPlayer.play("coin")


func _on_bonus_area_input_event(_viewport, event, _shape_idx):
	if  event is InputEventScreenTouch:
		match bonus_type:
			Bonuses.HEALTH:
				emit_signal("health_collected")
			Bonuses.COPILOT:
				emit_signal("copilot_collected")
			Bonuses.COIN:
				emit_signal("coin_collected")
			Bonuses.TIME:
				emit_signal("time_collected")
		get_tree().queue_delete(self)


func _on_visibility_timer_timeout():
	get_tree().queue_delete(self)
