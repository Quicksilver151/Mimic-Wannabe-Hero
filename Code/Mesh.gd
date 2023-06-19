extends Node2D

var default_points: PackedVector2Array = [
	Vector2.UP,
	(Vector2.UP + Vector2.RIGHT).normalized(),
	Vector2.RIGHT * 1.25,
	(Vector2.RIGHT + Vector2.DOWN).normalized(),
	Vector2.DOWN*0.8,
	(Vector2.DOWN + Vector2.LEFT).normalized(),
	Vector2.LEFT * 1.25,
	(Vector2.LEFT + Vector2.UP).normalized(),
]

func enlarge(points: PackedVector2Array, magnitude: float):
	var new_points: PackedVector2Array = []
	for point in points:
		var new_point: Vector2  = magnitude * point
		new_points.append(new_point)
	
	return new_points


func _draw():
	var points = enlarge(default_points, 6)
	print(points)
	var colors = PackedColorArray([Color.CORNFLOWER_BLUE])
	draw_polygon(points, colors)
	
