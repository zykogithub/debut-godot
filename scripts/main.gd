extends Node

@export var mob_scene : PackedScene
var score : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func new_game() -> void :
	score = 0
	$onlien_scene.entry_gestion()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$HUD/MessageTimer.start()
	get_tree().call_group("mobs","queue_free")
	$Music.play()


func end_session() :
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	
func game_over() -> void:
	$onlien_scene.end_game_gestion(score)
	end_session()
	$HUD.show_game_over()
	$DeathSound.play()
	
	
func _on_mob_timer_timeout() -> void:
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

func _on_score_timer_timeout() -> void:
	score +=1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()

func _on_score_scene_error() -> void:
	end_session()
	$SpecialEventLabel.text = $onlien_scene.server_result["error"]
	$SpecialEventLabel.show()
	$ErroTimer.start()
	


func _on_erro_timer_timeout() -> void:
	get_tree().quit(1)
