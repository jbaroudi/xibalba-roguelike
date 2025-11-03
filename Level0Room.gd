extends Node2D

@onready var tree_entrance = $TreeEntrance
@onready var tree_sprite = $Tree

func _ready():
	print("Starting room - Level 0 loaded")
	
	# Create tree sprite
	create_tree_sprite()
	
	# Configure the tree entrance
	if tree_entrance:
		tree_entrance.set_door_config("tree", "res://HiveHall.tscn", "hive_hall")
	
	# Check if this room has the flag
	if GameManager.is_flag_room():
		show_flag()

func add_debug_labels():
	# Add instruction label
	var instruction_label = Label.new()
	instruction_label.text = "Use ARROW KEYS to move\nWalk to the tree and press SPACE to enter"
	instruction_label.position = Vector2(50, 50)
	instruction_label.add_theme_color_override("font_color", Color.WHITE)
	add_child(instruction_label)

func create_tree_sprite():
	if tree_sprite:
		print("Creating tree with Polygon2D shapes...")
		# Remove any existing children
		for child in tree_sprite.get_children():
			child.queue_free()
		
		# Create tree using simple Polygon2D for maximum visibility (half size)
		# Tree trunk (half size)
		var trunk = Polygon2D.new()
		trunk.color = Color.SADDLE_BROWN
		trunk.z_index = 10  # Force to top
		trunk.polygon = PackedVector2Array([
			Vector2(-7, -5),     # Top left
			Vector2(7, -5),      # Top right  
			Vector2(7, 25),      # Bottom right
			Vector2(-7, 25)      # Bottom left
		])
		tree_sprite.add_child(trunk)
		print("Added brown tree trunk")
		
		# Tree canopy (main) - half size
		var canopy1 = Polygon2D.new()
		canopy1.color = Color.FOREST_GREEN
		canopy1.z_index = 11
		# Create an octagon for the main canopy (half size)
		canopy1.polygon = PackedVector2Array([
			Vector2(-20, -40),   # Top
			Vector2(-14, -46),   # Top left
			Vector2(14, -46),    # Top right
			Vector2(20, -40),    # Right top
			Vector2(20, -20),    # Right bottom
			Vector2(14, -14),    # Bottom right
			Vector2(-14, -14),   # Bottom left
			Vector2(-20, -20)    # Left bottom
		])
		tree_sprite.add_child(canopy1)
		print("Added green tree canopy")
		
		# Smaller upper canopy (half size)
		var canopy2 = Polygon2D.new()
		canopy2.color = Color.LIME_GREEN
		canopy2.z_index = 12
		canopy2.polygon = PackedVector2Array([
			Vector2(-12, -60),
			Vector2(12, -60),
			Vector2(17, -50),
			Vector2(12, -40),
			Vector2(-12, -40),
			Vector2(-17, -50)
		])
		tree_sprite.add_child(canopy2)
		print("Tree creation complete!")

func show_flag():
	print("FLAG FOUND! You win!")
	# Create a much larger flag visual
	var flag = Sprite2D.new()
	var texture = ImageTexture.new()
	var image = Image.create(80, 80, false, Image.FORMAT_RGB8)
	image.fill(Color.GOLD)
	
	# Add flag pattern to make it more recognizable
	for y in range(20, 60):
		for x in range(16, 64):
			if (x + y) % 12 < 6:
				image.set_pixel(x, y, Color.YELLOW)
	
	# Add bigger flagpole
	for y in range(0, 80):
		for x in range(8, 16):
			image.set_pixel(x, y, Color.SADDLE_BROWN)
	
	texture.set_image(image)
	flag.texture = texture
	flag.position = Vector2(300, 150)
	add_child(flag)
	
	# Add victory text
	var victory_label = Label.new()
	victory_label.text = "VICTORY! FLAG FOUND!"
	victory_label.position = Vector2(250, 80)
	victory_label.add_theme_color_override("font_color", Color.GOLD)
	add_child(victory_label)