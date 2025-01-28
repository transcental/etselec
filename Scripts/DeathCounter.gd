extends Label

var deaths = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "💀 0"


func _on_player_death() -> void:
	deaths += 1
	self.text = "💀 %s" % deaths
