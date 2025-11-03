extends Node2D

@onready var doors = []

func _ready():
	print("Hive Hall loaded")
	
	# Find all door nodes and configure them
	setup_doors()
	
	# Check if this room has the flag
	if GameManager.is_flag_room():
		show_flag()

func setup_doors():
	# Configure each door with proper target
	var door_configs = [
		{"node": $Door1, "id": "door1", "room": "room_1"},
		{"node": $Door2, "id": "door2", "room": "room_2"},
		{"node": $Door3, "id": "door3", "room": "room_3"},
		{"node": $Door4, "id": "door4", "room": "room_4"},
		{"node": $Door5, "id": "door5", "room": "room_5"},
		{"node": $Door6, "id": "door6", "room": "room_6"}
	]
	
	for config in door_configs:
		if config.node:
			config.node.set_door_config(
				config.id,
				"res://RegularRoom.tscn",
				config.room
			)
			doors.append(config.node)

func show_flag():
	print("FLAG FOUND IN HIVE HALL! You win!")
	# Create a larger flag visual
	var flag = Sprite2D.new()
	var texture = ImageTexture.new()
	var image = Image.create(48, 48, false, Image.FORMAT_RGB8)
	image.fill(Color.GOLD)
	
	# Add flag pattern to make it more recognizable
	for y in range(12, 36):
		for x in range(8, 40):
			if (x + y) % 8 < 4:
				image.set_pixel(x, y, Color.YELLOW)
	
	# Add flagpole
	for y in range(0, 48):
		for x in range(4, 8):
			image.set_pixel(x, y, Color.SADDLE_BROWN)
	
	texture.set_image(image)
	flag.texture = texture
	flag.position = Vector2(400, 300)
	add_child(flag)