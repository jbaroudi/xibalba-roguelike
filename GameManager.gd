extends Node

# Singleton GameManager to handle scene transitions and game state

signal scene_changed(new_scene)

var current_room_id = "town"
var visited_rooms = {}
var locked_doors = {}
var flag_room_id = ""
var max_rooms = 10
var created_rooms = 0

# Special doors that should never be locked (always available)
var always_available_doors = ["tree", "door4"]

# Room types
enum RoomType {
	TOWN,
	HIVE_HALL,
	REGULAR_ROOM
}

func _ready():
	# Initialize the game state
	visited_rooms[current_room_id] = true
	# Clear any previously locked always-available doors
	clear_always_available_doors()
	# Randomly place flag in one of the potential rooms
	place_flag_randomly()

func clear_always_available_doors():
	# Remove any locks on always-available doors
	var keys_to_remove = []
	for lock_key in locked_doors.keys():
		for door_id in always_available_doors:
			if lock_key.ends_with("_" + door_id):
				keys_to_remove.append(lock_key)
	
	for key in keys_to_remove:
		locked_doors.erase(key)
		print("Cleared lock on always-available door: ", key)

func place_flag_randomly():
	# Generate a random room ID where the flag will be placed
	var room_number = randi() % max_rooms + 1
	flag_room_id = "room_" + str(room_number)
	print("Flag placed in: ", flag_room_id)

func change_scene(scene_path: String, new_room_id: String, from_door_id: String = ""):
	if created_rooms >= max_rooms and not visited_rooms.has(new_room_id):
		print("Max rooms reached, cannot create new room")
		return false
		
	# Lock the door we came from, unless it's an always-available door
	if from_door_id != "" and not always_available_doors.has(from_door_id):
		var lock_key = current_room_id + "_" + from_door_id
		locked_doors[lock_key] = true
		print("Locked door: ", lock_key)
	elif from_door_id != "" and always_available_doors.has(from_door_id):
		print("Door ", from_door_id, " is always available - not locking")
	
	# Mark new room as visited
	if not visited_rooms.has(new_room_id):
		visited_rooms[new_room_id] = true
		created_rooms += 1
		print("Created room ", created_rooms, "/", max_rooms)
	
	current_room_id = new_room_id
	
	# Change to the new scene
	get_tree().change_scene_to_file(scene_path)
	scene_changed.emit(scene_path)
	return true

func is_door_locked(room_id: String, door_id: String) -> bool:
	# Always-available doors are never considered locked
	if always_available_doors.has(door_id):
		return false
		
	var lock_key = room_id + "_" + door_id
	return locked_doors.has(lock_key)

func is_flag_room() -> bool:
	return current_room_id == flag_room_id

func get_available_room_count() -> int:
	return max_rooms - created_rooms

func can_create_new_room() -> bool:
	return created_rooms < max_rooms