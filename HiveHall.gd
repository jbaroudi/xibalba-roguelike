extends Node2D

@onready var doors = []

func _ready():
	print("Hive Hall loaded")
	
	# Find all door nodes and configure them
	setup_doors()
	
	# Add door labels for better navigation
	add_door_labels()
	
	# Check if this room has the flag
	if GameManager.is_flag_room():
		show_flag()

func add_door_labels():
	# Add small labels near each door to indicate what they lead to
	var label_configs = [
		{"position": Vector2(800, 370), "text": "Room 1", "door": 1},
		{"position": Vector2(1030, 470), "text": "Room 2", "door": 2},
		{"position": Vector2(1030, 730), "text": "Room 3", "door": 3},
		{"position": Vector2(800, 830), "text": "Town", "door": 4},
		{"position": Vector2(570, 730), "text": "Room 5", "door": 5},
		{"position": Vector2(570, 470), "text": "Room 6", "door": 6}
	]
	
	for config in label_configs:
		var label = Label.new()
		label.text = config.text
		label.position = config.position
		label.add_theme_color_override("font_color", Color.WHITE)
		label.z_index = 5
		
		# Make the town label different color
		if config.door == 4:
			label.add_theme_color_override("font_color", Color.GRAY)
		
		add_child(label)

func setup_doors():
	# Configure each door with proper target
	var door_configs = [
		{"node": $Door1, "id": "door1", "room": "room_1"},
		{"node": $Door2, "id": "door2", "room": "room_2"},
		{"node": $Door3, "id": "door3", "room": "room_3"},
		{"node": $Door4, "id": "door4", "room": "town", "scene": "res://Town.tscn", "entrance": true},
		{"node": $Door5, "id": "door5", "room": "room_5"},
		{"node": $Door6, "id": "door6", "room": "room_6"}
	]
	
	for config in door_configs:
		if config.node:
			var target_scene = config.get("scene", "res://RegularRoom.tscn")
			config.node.set_door_config(
				config.id,
				target_scene,
				config.room
			)
			
			# Mark Door4 as entrance door (make it gray/closed looking)
			if config.has("entrance") and config.entrance:
				config.node.door_enabled = true  # Still functional
				config.node.create_entrance_door()  # Special appearance
			
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