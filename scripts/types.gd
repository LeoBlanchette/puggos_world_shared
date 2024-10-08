class_name Types

## Types of Emotes. 
## THOUGHT is an emote seen only by the player.
## COMMUNICATION is an emote seen by all players.
enum EmoteType{
	NONE,
	THOUGHT,
	URGENT_THOUGHT,
	COMMUNICATION,
	URGENT_COMMUNICATION,
}

enum ModularStructureType{
	NONE,
	FLOOR,
	WALL_1,
	WALL_2,
	PILLAR,
	INTERIOR_MODULE,
	BLOCK,
}

enum CompassDirection{
	NONE,
	NORTH,
	NORTH_EAST,
	EAST,
	SOUTH_EAST,
	SOUTH,
	SOUTH_WEST,
	WEST,
	NORTH_WEST,
}
