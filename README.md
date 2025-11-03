# Xibalba Roguelike Game

A simple roguelike game built in Godot 4.5 where you explore interconnected rooms to find a hidden flag.

## Game Features

- **Starting Room (Level 0)**: Begin your journey in a green outdoor area with a tree entrance
- **Hive Hall**: Central hub with 6 doors arranged in a hexagonal pattern
- **Interconnected Rooms**: Each room can lead to up to 6 other rooms, creating a complex network
- **Room Limitations**: Maximum of 10 rooms to prevent infinite generation
- **Door Locking**: Doors you've used become locked, preventing backtracking
- **Hidden Flag**: A golden flag is randomly placed in one of the rooms - find it to win!

## Controls

- **Arrow Keys**: Move your character (blue square)
- **Space Bar**: Interact with doors to enter new rooms

## How to Play

1. Start in Level 0 room with a tree
2. Walk to the tree entrance and press Space to enter the Hive Hall
3. Choose one of the 6 doors in the Hive Hall to explore
4. Navigate through the interconnected rooms
5. Find the golden flag to win the game!

## Technical Details

- Built with Godot 4.5
- Simple pixel art style using procedurally generated sprites
- Room limit system prevents infinite room creation
- Door locking system creates strategic choices
- Random flag placement for replayability

## File Structure

- `Town.tscn/gd`: Starting room with tree entrance
- `HiveHall.tscn/gd`: Central hub with 6 doors
- `RegularRoom.tscn/gd`: Template for interconnected rooms
- `Player.tscn/gd`: Character controller with movement and interaction
- `Door.tscn/gd`: Reusable door system for scene transitions
- `GameManager.gd`: Singleton managing game state, room tracking, and flag placement

## How to Run

1. Open the project in Godot 4.5
2. Press F5 or click "Play" to run the game
3. The main scene is automatically set to `Town.tscn`

## Game Mechanics

- **Room Creation**: New rooms are created dynamically up to the limit of 10
- **Door Availability**: Doors are only shown if new rooms can be created or if they lead to existing rooms
- **Victory Condition**: Find the golden flag that's randomly placed in one of the rooms
- **Exploration Strategy**: Plan your path carefully as used doors become locked

Enjoy exploring the maze-like structure of Xibalba!
