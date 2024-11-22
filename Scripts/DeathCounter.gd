extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "💀 0"


func _on_player_died(deaths: Variant) -> void:
	print('trying to update', deaths)
	self.text = "💀 %s" % deaths
