extends CharacterBody2D

@export var speed = 200.0

@onready var sprite = $Sprite2D

func _ready():
	# Create a simple and very visible player shape
	create_simple_player()

func create_simple_player():
	print("Creating player with Polygon2D shapes...")
	# Remove sprite approach, add direct polygon children to the player node
	var player_body = Polygon2D.new()
	player_body.color = Color.WHITE
	player_body.z_index = 10  # Force to top
	# Create a simple square (half size)
	player_body.polygon = PackedVector2Array([
		Vector2(-10, -10),
		Vector2(10, -10),
		Vector2(10, 10),
		Vector2(-10, 10)
	])
	add_child(player_body)
	print("Added white player body")
	
	# Add a smaller inner rectangle for contrast (half size)
	var player_inner = Polygon2D.new()
	player_inner.color = Color.BLUE
	player_inner.z_index = 11  # Even higher
	player_inner.polygon = PackedVector2Array([
		Vector2(-7, -7),
		Vector2(7, -7),
		Vector2(7, 7),
		Vector2(-7, 7)
	])
	add_child(player_inner)
	print("Added blue player inner")
	
	# Add eyes (half size)
	var eye1 = Polygon2D.new()
	eye1.color = Color.BLACK
	eye1.z_index = 12
	eye1.polygon = PackedVector2Array([
		Vector2(-5, -5),
		Vector2(-3, -5),
		Vector2(-3, -3),
		Vector2(-5, -3)
	])
	add_child(eye1)
	
	var eye2 = Polygon2D.new()
	eye2.color = Color.BLACK
	eye2.z_index = 12
	eye2.polygon = PackedVector2Array([
		Vector2(3, -5),
		Vector2(5, -5),
		Vector2(5, -3),
		Vector2(3, -3)
	])
	add_child(eye2)
	print("Player creation complete!")

func _physics_process(_delta):
	# Handle movement input using direct key detection
	var input_vector = Vector2.ZERO
	
	if Input.is_key_pressed(KEY_RIGHT) or Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_key_pressed(KEY_LEFT) or Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_key_pressed(KEY_DOWN) or Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_key_pressed(KEY_UP) or Input.is_action_pressed("ui_up"):
		input_vector.y -= 1
	
	# Normalize diagonal movement
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()
	
	# Apply screen boundaries (assuming 1600x1200 screen size)
	var screen_margin = 20  # Keep player away from exact edge
	position.x = clamp(position.x, screen_margin, 1600 - screen_margin)
	position.y = clamp(position.y, screen_margin, 1200 - screen_margin)

func _input(event):
	# Handle interaction using multiple keys
	if event.is_action_pressed("ui_accept") or (event is InputEventKey and event.pressed and event.keycode == KEY_SPACE):
		interact_with_nearby_objects()

func interact_with_nearby_objects():
	# Check for nearby interactable objects using the interaction area
	var area = $InteractionArea
	var overlapping_areas = area.get_overlapping_areas()
	
	for overlapping_area in overlapping_areas:
		if overlapping_area.has_method("interact"):
			overlapping_area.interact()
			break