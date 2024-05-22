extends CharacterBody2D
signal process_hit
signal process_teleported

@export var speed = 100
@export var pos = Vector2(0,0) #default screen center

func _ready():
	$AnimationPlayer.play("walk")
	pos = Vector2(0,0)
	
func _physics_process(delta):
	rotation = position.angle_to_point(pos) 
	var movement = speed * position.direction_to(pos) * delta
	var _collision = move_and_collide(movement)
		


func _on_process_area_area_entered(area):
	if area.name == "Teleport":
		$AnimationPlayer.play("teleport")


func _on_animation_player_animation_finished(anim):
	if anim == "teleport":
		emit_signal("process_teleported")
		get_tree().queue_delete(self)


func _on_process_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventScreenTouch:
		$HitParticles.emitting = true 
		emit_signal("process_hit")
