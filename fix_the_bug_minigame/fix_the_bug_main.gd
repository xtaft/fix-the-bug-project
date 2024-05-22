extends Node2D
signal bug_transformed
signal bug_teleported
signal copilot_collected
signal coin_collected
signal time_collected
signal new_game
signal process_hit
signal process_teleported

var health = 100
var health_damage = 10
var score = 0
var playing = false
var coins = 0
var character_speed = 80
var time_bonus = false
var best_score = 0
var spawning_wave = false
var spawning_speed = 1
var wave_timer_time = 3.0
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$ProcessSpawnTimer.stop()
	$BugSpawnTimer.stop()
	$BonusSpawnTimer.stop()
	$NewGame.first_game = true
	
 # Called every frame. 'delta' is the elapsed time since the previous frame.   
func _process(_delta):
	if health <= 0:
		game_over()
	$Score/ScoreLabel.text = str(score)
	$Health/HealthBar.value = health
	
func _on_new_game_new_game():
	health = 100
	score = 0
	playing = true
	coins = 0
	character_speed = 80
	spawning_speed = 1
	for bug in get_tree().get_nodes_in_group("Bugs"):
		bug.queue_free()
	for process in get_tree().get_nodes_in_group("Processes"):
		process.queue_free()
	$NewGame.hide()
	$BugSpawnTimer.start()
	$ProcessSpawnTimer.start()
	$BonusSpawnTimer.start()
	
func game_over():
	for bonus in get_tree().get_nodes_in_group("Bonuses"):
		bonus.queue_free()
	if best_score < score:
		best_score = score
	$NewGame/ReplayGame/BestScoreValue/BestSCoreValue.text = str(best_score)
	$NewGame/ReplayGame/GameScore/GameScore.text = str(score)
	$NewGame/ReplayGame/Coins/Coins.text = "+ " + str(coins)
	$NewGame.show()
	$ProcessSpawnTimer.stop()
	$BugSpawnTimer.stop()
	$BonusSpawnTimer.stop()


func _on_bug_spawn_timer_timeout():
	var bug = FixTheBugGlobal.bug.instantiate()
	bug.add_to_group("Bugs")
	$Spawner.spawn_character(bug, $Bugs)
	bug.speed = character_speed
	bug.pos = $Teleport.position
	bug.connect("bug_transformed", _on_bug_transformed)
	bug.connect("bug_teleported", _on_bug_teleported)


func _on_process_spawn_timer_timeout():
	var proc = FixTheBugGlobal.process.instantiate()
	proc.add_to_group("Processes")
	$Spawner.spawn_character(proc, $Processes)
	proc.speed = character_speed
	proc.pos = $Teleport.position
	proc.connect("process_hit", _on_process_hit)
	proc.connect("process_teleported", _on_process_teleported)
	
func _on_process_hit():
	score -= 10
	
func _on_process_teleported():
	pass


func _on_bug_transformed(pos):
	score += 55
	var proc = FixTheBugGlobal.process.instantiate()
	proc.position = pos
	proc.add_to_group("Processes")
	$Processes.add_child(proc)
	proc.speed = character_speed
	proc.pos = $Teleport.position
	
func _on_bug_teleported():
	health -= health_damage


func _on_bonus_spawn_timer_timeout():
	var bonus = FixTheBugGlobal.bonus.instantiate()
	bonus.add_to_group("Bonuses")
	$Spawner.spawn_bonus(bonus, $Bonuses)
	bonus.connect("health_collected", _on_health_collected)
	bonus.connect("copilot_collected", _on_copilot_collected)
	bonus.connect("coin_collected", _on_coin_collected)
	bonus.connect("time_collected", _on_time_collected)


func _on_health_collected():
	health = 100


func _on_coin_collected():
	coins += 1


func _on_copilot_collected():
	for bug in get_tree().get_nodes_in_group("Bugs"):
		bug.transform()


func _on_time_collected():
	if time_bonus:
		return
	time_bonus = true
	for bug in get_tree().get_nodes_in_group("Bugs"):
		bug.speed = character_speed * 0.5
	$TimeBonusTimer.start()
	
func _on_time_bonus_timer_timeout():
	time_bonus = false


func _on_spawning_wave_timer_timeout():
	if not spawning_wave:
		spawning_speed *= 0.8
		spawning_wave = true
		character_speed += 2
		wave_timer_time *= 0.2
	else:
		$ProcessSpawnTimer.set_wait_time($ProcessSpawnTimer.wait_time * 1.05)
		spawning_speed *= 1.2
		spawning_wave = false
		wave_timer_time *= 5.0
	$SpawningWaveTimer.set_wait_time(wave_timer_time)
	$BugSpawnTimer.set_wait_time(spawning_speed)
