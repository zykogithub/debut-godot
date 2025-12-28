extends CanvasLayer

signal start_game


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func show_message(text : String) -> void :
	$Message.text = text
	$Message.show()

func update_score(score : int) -> void :
	$ScoreLabel.text = str(score)

func show_game_over() -> void :
	show_message("game_over")
	$MessageTimer.start()
	
	await $MessageTimer.timeout	
	
	show_message("Dodge the Creeps!")
	
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
