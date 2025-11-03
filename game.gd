extends Node

# Main game controller

func _ready():
	print("Xibalba Roguelike Game Started!")
	print("Use ARROW KEYS to move")
	print("Press SPACE to interact with doors")
	print("Find the golden flag hidden in one of the rooms!")
	
	# Start the game by loading the initial scene
	get_tree().change_scene_to_file("res://Level0Room.tscn")