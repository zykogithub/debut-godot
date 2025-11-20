extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = Node2D.new()
	var entier := 50
	hello(node,entier)
	print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hello(node : Node2D, entier : int = 1) -> void :
	entier = 3
	node.position.x += entier
