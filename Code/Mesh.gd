extends Node2D

@onready var parent = self.get_parent() if self.get_node_or_null("../") != null else self
@export_category("stats")
@export var DEFAULT_POINTS: PackedVector2Array = [
	Vector2.UP,
	(Vector2.UP + Vector2.RIGHT).normalized(),
	Vector2.RIGHT * 1.25,
	(Vector2.RIGHT + Vector2.DOWN).normalized(),
	Vector2.DOWN*0.8,
	(Vector2.DOWN + Vector2.LEFT).normalized(),
	Vector2.LEFT * 1.25,
	(Vector2.LEFT + Vector2.UP).normalized(),
]
@export var SIZE = 6
@export_range(0,5,1) var SMOOTHNESS = 1
@export var core_points = DEFAULT_POINTS
# plan:
# have polygon node
# use points from node and modify em
# get_motion()
# apply motion to points
# subdivide()
# scale()
# draw()

func subdivision(smoothness: int, points: PackedVector2Array) -> PackedVector2Array:
	var subdivided_points = points.duplicate()
	
	for x in range(smoothness):
		var new_points = []
		var num_points = subdivided_points.size()
		
		for i in range(num_points):
			var current_point = subdivided_points[i]
			var next_point = subdivided_points[(i + 1) % num_points]  # Wrap around to the first point
		
			var quarter_point = Vector2(
				(3 * current_point.x + next_point.x) / 4,
				(3 * current_point.y + next_point.y) / 4
			)
			var three_quarter_point = Vector2(
				(current_point.x + 3 * next_point.x) / 4,
				(current_point.y + 3 * next_point.y) / 4
			)

			new_points.append(quarter_point)
			new_points.append(three_quarter_point)

		subdivided_points = new_points

	return subdivided_points



func _physics_process(delta):
	
	
	
	
	queue_redraw()


func enlarge(points: PackedVector2Array, magnitude: float):
	var new_points: PackedVector2Array = []
	for point in points:
		var new_point: Vector2  = magnitude * point
		new_points.append(new_point)
		
	return new_points


func _draw():
	var final_points = subdivision(SMOOTHNESS, enlarge(core_points, SIZE))
#	print(final_points)
	var colors = PackedColorArray([Color.BLUE])
	var colors2 =  Color.DARK_BLUE
	draw_polygon(final_points, colors)
	final_points.append(final_points[0])
	draw_polyline(final_points,colors2)
	
