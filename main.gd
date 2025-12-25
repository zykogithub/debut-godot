extends Node

@export var mob_scene : PackedScene
var score : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func new_game() -> void :
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD/MessageTimer.start()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_location = $MobPath/MobSpawLocation
	var direction = mob_location.rotation + PI /2
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	
	mob_location.progress_ratio = randf()
	mob.position = mob_location.position
	direction += randf_range(-PI /4, PI/4)
	mob.rotation = direction
	mob.linear_velocity = velocity
	
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score +=1

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
	
	
	
	
	
	
