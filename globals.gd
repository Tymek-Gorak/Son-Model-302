extends Node
# GLOBALS

# TODO ADD fence sprites
var fence_dictionary = {
	[Vector2i.UP, Vector2i.DOWN] : Vector2(1,0),
	[Vector2i.UP, Vector2i.RIGHT] : Vector2(-1,1),
	[Vector2i.RIGHT, Vector2i.LEFT] : Vector2(0,1),
	[Vector2i.DOWN, Vector2i.RIGHT] : Vector2(-1,-1),
	[Vector2i.DOWN, Vector2i.UP] : Vector2(1,0),
	[Vector2i.DOWN, Vector2i.LEFT] : Vector2(1,-1),
	[Vector2i.LEFT, Vector2i.RIGHT] : Vector2(0,1),
	[Vector2i.LEFT, Vector2i.UP] : Vector2(1,1),
	[Vector2i.UP] : Vector2(1,0),
	[Vector2i.RIGHT] : Vector2(0,1),
	[Vector2i.DOWN] : Vector2(1,0),
	[Vector2i.LEFT] : Vector2(0,1),
}
