class_name TileMapsChefGeometryUtils

static func get_local_polygon(polygon: Polygon2D) -> PackedVector2Array:
	return polygon_to_local(polygon.polygon, polygon.position)

static func polygon_to_local(polygon: PackedVector2Array, position: Vector2) -> PackedVector2Array:
	var array: Array[Vector2] = []
	for point in polygon:
		array.append(position + point)
		
	return PackedVector2Array(array)
