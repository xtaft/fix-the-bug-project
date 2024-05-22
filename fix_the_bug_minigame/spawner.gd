extends Node2D

enum Bonuses { HEALTH, TIME, COIN, COPILOT}
@export var bonus_type:Bonuses

func _ready():
	pass
	
func spawn_character(inst, parent):
	var spawn_location = get_node("CharacterSpawnPath/CharacterSpawnLocation")
	spawn_location.progress_ratio = randf()
	inst.position = spawn_location.position
	parent.add_child(inst)
	
func spawn_bonus(inst, parent):
	var spawn_location = get_node("BonusSpawnPath/BonusSpawnLocation")
	spawn_location.progress_ratio = randf()
	inst.global_position = spawn_location.position
	parent.add_child(inst)
	

func _on_input_event(_viewport, event, _shape_idx):
	if  event is InputEventScreenTouch:
		get_tree().queue_delete(self)

func _on_timer_timeout():
	get_tree().queue_delete(self)
