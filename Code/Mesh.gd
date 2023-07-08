extends Node2D

@onready var parent = self.get_parent() if self.get_node_or_null("../") != null else self
@export_category("stats")
#@export var DEFAULT_POINTS: PackedVector2Array = [
#	Vector2.UP,
#	(Vector2.UP + Vector2.RIGHT).normalized(),
#	Vector2.RIGHT * 1.25,
#	(Vector2.RIGHT + Vector2.DOWN).normalized(),
#	Vector2.DOWN*0.8,
#	(Vector2.DOWN + Vector2.LEFT).normalized(),
#	Vector2.LEFT * 1.25,
#	(Vector2.LEFT + Vector2.UP).normalized(),
#]
@onready var DEFAULT_POINTS = $POINTS.polygon
@export var SIZE = 6
@export_range(0,5,1) var SMOOTHNESS = 1
@onready var core_points = DEFAULT_POINTS
# plan:
# have polygon node
# use points from node and modify em
# set_drag(POINTS, change in global position?)

# interpolate global pos but with a min range
# subdivide()
# scale()
# draw()
var drag_points:PackedVector2Array = [] # exists in global pixel coordinates
func set_drag(points: PackedVector2Array):
	var min_points = points
	
	for i in drag_points.size():
		drag_points[i] = drag_points[i].lerp(min_points[i] + (global_position/SIZE),0.1)
	
	
	return drag_points

var prev_global_pos = self.global_position
var func_timer = 0.0
var new_global_pos = global_position
func get_change_in_global_pos(delta:float, time:float = 0.1):
	func_timer += delta
	var change
	if func_timer > time:
		change = new_global_pos - prev_global_pos
		prev_global_pos = new_global_pos
		new_global_pos = global_position
		func_timer = 0
	
	return change


func _ready():
	drag_points = core_points
	$bg.visible = false

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


var global_change = Vector2.ZERO
func _physics_process(delta):
	core_points = $POINTS.polygon
	var gpos = global_position
	var x = get_change_in_global_pos(delta)
	if x:
		global_change = x
	else:
		pass
	
	queue_redraw()


func enlarge(points: PackedVector2Array, magnitude: float, center:Vector2 = Vector2.ZERO):
	var new_points: PackedVector2Array = []
	for point in points:
		var new_point: Vector2  = magnitude * (point - center)
		new_points.append(new_point)
		
	return new_points

func translate_points(points: PackedVector2Array, pos:Vector2):
	var new_points:PackedVector2Array
	for point in points:
		new_points.append(point+pos)
	
	return new_points

func _draw():
	
	var final_points = subdivision(SMOOTHNESS, enlarge(core_points, SIZE))
#	print(final_points)
	var colors = PackedColorArray([Color("4b80ca")])
	var colors2 =  Color("3a3858")
	final_points = translate_points(final_points,-global_change/SIZE)
	draw_polygon(final_points, colors)
	var okk = subdivision(SMOOTHNESS,translate_points(enlarge(drag_points, SIZE), global_position))
	draw_polygon(okk, colors)
	
	final_points.append(final_points[0])
	draw_polyline(final_points,colors2)
	
