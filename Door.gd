extends Area2D

@export var door_id: String = ""
@export var target_scene: String = ""
@export var target_room_id: String = ""
@export var door_enabled: bool = true

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D

var player_nearby = false

func _ready():
	# Create door appearance
	if sprite == null:
		sprite = Sprite2D.new()
		add_child(sprite)
	
	if collision == null:
		collision = CollisionShape2D.new()
		var shape = RectangleShape2D.new()
		shape.size = Vector2(32, 48)
		collision.shape = shape
		add_child(collision)
	
	# Create door texture
	create_door_texture()
	
	# Connect signals
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Set collision layers
	collision_layer = 2  # Interactable layer
	collision_mask = 1   # Player layer
	
	update_door_state()

func create_door_texture():
	# Remove any existing children from sprite
	for child in sprite.get_children():
		child.queue_free()
	
	# Create door using ColorRect for better visibility (half size)
	var door_rect = ColorRect.new()
	
	if door_enabled:
		door_rect.color = Color.SADDLE_BROWN
		door_rect.size = Vector2(24, 36)
		door_rect.position = Vector2(-12, -18)
		sprite.add_child(door_rect)
		
		# Add door frame (half size)
		var frame_top = ColorRect.new()
		frame_top.color = Color.BLACK
		frame_top.size = Vector2(26, 2)
		frame_top.position = Vector2(-13, -19)
		sprite.add_child(frame_top)
		
		var frame_bottom = ColorRect.new()
		frame_bottom.color = Color.BLACK
		frame_bottom.size = Vector2(26, 2)
		frame_bottom.position = Vector2(-13, 18)
		sprite.add_child(frame_bottom)
		
		var frame_left = ColorRect.new()
		frame_left.color = Color.BLACK
		frame_left.size = Vector2(2, 40)
		frame_left.position = Vector2(-13, -19)
		sprite.add_child(frame_left)
		
		var frame_right = ColorRect.new()
		frame_right.color = Color.BLACK
		frame_right.size = Vector2(2, 40)
		frame_right.position = Vector2(11, -19)
		sprite.add_child(frame_right)
		
		# Add door handle (half size)
		var handle = ColorRect.new()
		handle.color = Color.GOLD
		handle.size = Vector2(3, 4)
		handle.position = Vector2(-10, -2)
		sprite.add_child(handle)
	else:
		door_rect.color = Color.GRAY
		door_rect.size = Vector2(24, 36)
		door_rect.position = Vector2(-12, -18)
		sprite.add_child(door_rect)
		
		# Add X pattern to show it's blocked (half size)
		var x1 = ColorRect.new()
		x1.color = Color.RED
		x1.size = Vector2(2, 40)
		x1.position = Vector2(-1, -19)
		x1.rotation = deg_to_rad(45)
		sprite.add_child(x1)
		
		var x2 = ColorRect.new()
		x2.color = Color.RED
		x2.size = Vector2(2, 40)
		x2.position = Vector2(-1, -19)
		x2.rotation = deg_to_rad(-45)
		sprite.add_child(x2)

func update_door_state():
	var is_locked = GameManager.is_door_locked(GameManager.current_room_id, door_id)
	var can_create = GameManager.can_create_new_room()
	
	# Door is available if it's enabled, not locked, and we can create rooms OR target already exists
	door_enabled = door_enabled and not is_locked and (can_create or GameManager.visited_rooms.has(target_room_id))
	
	create_door_texture()
	visible = door_enabled

func _on_body_entered(body):
	if body.name == "Player":
		player_nearby = true
		if door_enabled:
			print("Press SPACE to enter door")

func _on_body_exited(body):
	if body.name == "Player":
		player_nearby = false

func interact():
	if not door_enabled or not player_nearby:
		return
		
	if target_scene == "" or target_room_id == "":
		print("Door not properly configured")
		return
		
	print("Entering door: ", door_id, " -> ", target_room_id)
	
	# Attempt to change scene
	var success = GameManager.change_scene(target_scene, target_room_id, door_id)
	if not success:
		print("Cannot enter door - room limit reached")

func set_door_config(id: String, scene: String, room_id: String, enabled: bool = true):
	door_id = id
	target_scene = scene
	target_room_id = room_id
	door_enabled = enabled
	update_door_state()