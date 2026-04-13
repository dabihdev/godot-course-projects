extends Control

@onready var player: CharacterBody2D = $"../../Player"
@onready var hp_label: Label = $HP


func _ready():
	update_label()

func update_label():
	hp_label.text = "HP: "+str(player.current_hp)+"/"+str(player.max_hp)
