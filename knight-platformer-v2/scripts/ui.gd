extends Control

@onready var player: CharacterBody2D = $"../../Player"
@onready var hp_label: Label = $HP


func _ready():
	Signals.gain_hp.connect(update_hp)
	hp_label.text = "HP: "+str(player.current_hp)+"/"+str(player.max_hp)

func update_hp():
	var total_hp = player.current_hp + 10
	if total_hp > player.max_hp:
		player.current_hp = player.max_hp
	else:
		player.current_hp = total_hp
	hp_label.text = "HP: "+str(player.current_hp)+"/"+str(player.max_hp)
