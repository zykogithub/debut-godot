extends Node

@export var mob_scene : PackedScene
var score : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game() -> void :
	score = 0
	$StartTimer.start()

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
func _on_mob_timer_timeout() -> void:
	pass # Replace with function body.


func _on_score_timer_timeout() -> void:
	score +=1

func _on_start_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	var mob_location = $MobPath/MobSpawLocation
	mob_location.progress_ratio = randf()
	mob.position = mob_location.position
	var direction = mob_location.rotation + PI /2
	direction += randf_range(-PI /4, PI/4)
	mob.rotation = direction
	var velocity = Vector2(randf_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity
	
	add_child(mob)
	
	
	
	
	
	
