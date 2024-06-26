extends CharacterBody2D

signal bug_transformed
signal bug_teleported

@export var speed = 80


func _ready():
	$AnimationPlayer.play("walk")

	
func _physics_process(delta):
	rotation = position.angle_to_point(get_viewport_rect().size / 2.0)
	var movement = speed * position.direction_to(get_viewport_rect().size / 2.0) * delta
	var _collision = move_and_collide(movement)


func _on_animation_player_animation_finished(anim):
	if anim == "transform":
		get_tree().queue_delete(self)
		emit_signal("bug_transformed", position)
	if anim == "teleport":
		get_tree().queue_delete(self)


func _on_bug_area_input_event(_viewport, event, _shape_idx):
	if  event is InputEventScreenTouch:
		transform()
	
func transform():
	$TransformParticles.emitting = true
	$AnimationPlayer.play("transform")

func _on_bug_area_area_entered(area):
	if area.name == "Teleport":
		$AnimationPlayer.play("teleport")
		bug_teleported.emit()
