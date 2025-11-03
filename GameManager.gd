extends Node

# Singleton GameManager to handle scene transitions and game state

signal scene_changed(new_scene)

var current_room_id = "town"
var visited_rooms = {}
var locked_doors = {}
var flag_room_id = ""
var max_rooms = 10
var created_rooms = 0

# Room types
enum RoomType {
	TOWN,
	HIVE_HALL,
	REGULAR_ROOM
}

func _ready():
	# Initialize the game state
	visited_rooms[current_room_id] = true
	# Randomly place flag in one of the potential rooms
	place_flag_randomly()

func place_flag_randomly():
	# Generate a random room ID where the flag will be placed
	var room_number = randi() % max_rooms + 1
	flag_room_id = "room_" + str(room_number)
	print("Flag placed in: ", flag_room_id)

func change_scene(scene_path: String, new_room_id: String, from_door_id: String = ""):
	if created_rooms >= max_rooms and not visited_rooms.has(new_room_id):
		print("Max rooms reached, cannot create new room")
		return false
		
	# Lock the door we came from
	if from_door_id != "":
		var lock_key = current_room_id + "_" + from_door_id
		locked_doors[lock_key] = true
		print("Locked door: ", lock_key)
	
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
	var lock_key = room_id + "_" + door_id
	return locked_doors.has(lock_key)

func is_flag_room() -> bool:
	return current_room_id == flag_room_id

func get_available_room_count() -> int:
	return max_rooms - created_rooms

func can_create_new_room() -> bool:
	return created_rooms < max_rooms