extends Node2D

@onready var doors = []

func _ready():
	print("Regular room loaded: ", GameManager.current_room_id)
	
	# Setup doors for this room
	setup_doors()
	
	# Check if this room has the flag
	if GameManager.is_flag_room():
		show_flag()

func setup_doors():
	# Configure doors based on current room and available connections
	var door_nodes = [$Door1, $Door2, $Door3, $Door4, $Door5, $Door6]
	var door_count = 0
	
	for i in range(door_nodes.size()):
		var door = door_nodes[i]
		if door == null:
			continue
			
		var door_id = "door" + str(i + 1)
		var target_room_id = generate_target_room_id(i + 1)
		
		# Check if we should enable this door
		var should_enable = should_enable_door(door_id, target_room_id)
		
		if should_enable:
			door.set_door_config(
				door_id,
				"res://RegularRoom.tscn",
				target_room_id,
				true
			)
			door_count += 1
		else:
			door.visible = false
			door.door_enabled = false
		
		doors.append(door)
	
	print("Enabled ", door_count, " doors in room ", GameManager.current_room_id)

func generate_target_room_id(door_number: int) -> String:
	# Generate connected room IDs based on current room
	var current_id = GameManager.current_room_id
	var base_number = 0
	
	# Extract number from current room ID
	if current_id.begins_with("room_"):
		base_number = int(current_id.split("_")[1])
	
	# Generate target room ID (this creates the interconnected network)
	var target_number = (base_number * 6) + door_number
	if target_number > GameManager.max_rooms:
		target_number = (target_number % GameManager.max_rooms) + 1
	
	return "room_" + str(target_number)

func should_enable_door(door_id: String, target_room_id: String) -> bool:
	# Don't enable if door is locked
	if GameManager.is_door_locked(GameManager.current_room_id, door_id):
		return false
	
	# Don't enable if we can't create new rooms and target doesn't exist
	if not GameManager.can_create_new_room() and not GameManager.visited_rooms.has(target_room_id):
		return false
	
	# Randomly enable some doors to create variety
	return randf() > 0.3  # 70% chance to enable each door

func show_flag():
	print("FLAG FOUND IN ROOM ", GameManager.current_room_id, "! You win!")
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
	flag.position = Vector2(400, 200)
	add_child(flag)
	
	# Add victory text
	var label = Label.new()
	label.text = "VICTORY!\nFlag Found!"
	label.position = Vector2(350, 100)
	label.add_theme_color_override("font_color", Color.GOLD)
	add_child(label)