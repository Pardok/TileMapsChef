@tool
extends EditorPlugin

var container: Container
var custom_button: Button
var selected_tilemaps: Array[TileMap]
var selected_nav_region: NavigationRegion2D

const GeometryUtils = preload("res://addons/tile_maps_chef/utils/geometry.gd")

func _enter_tree():
	var editor_selection = get_editor_interface().get_selection()
	editor_selection.connect("selection_changed", _on_selection_changed)

func _exit_tree():
	_remove_current_nav_region_control()


func _on_selection_changed():
	var editor_selection = get_editor_interface().get_selection()
	var selected_objects = editor_selection.get_selected_nodes()
	print(selected_objects)

	_remove_current_nav_region_control()
	if selected_objects.size() > 0 and selected_objects[0] is NavigationRegion2D:
		selected_nav_region = selected_objects[0]
	else:
		selected_nav_region = null
	selected_tilemaps.assign(selected_objects.filter(func(obj): return obj is TileMap))
	if (selected_nav_region != null) and (selected_tilemaps.size() > 0):
		_add_control_for_selected_nav_region()
		

func _add_control_for_selected_nav_region():
	custom_button = Button.new()
	custom_button.text = "Bake NavigationPolygon \"%s\" from TileMaps" % selected_nav_region.name
	custom_button.connect("pressed", _on_custom_button_pressed)
	
	container = MarginContainer.new()
	container.size = Vector2(200, 200);
	container.add_child(custom_button);

	add_control_to_bottom_panel(container, "TileChef")
	
func _remove_current_nav_region_control():
	remove_control_from_bottom_panel(container)

func _on_custom_button_pressed():
	var nav_data = NavigationMeshSourceGeometryData2D.new()
	var nav_polygon = NavigationPolygon.new()
	NavigationServer2D.parse_source_geometry_data(selected_nav_region.navigation_polygon, nav_data, selected_nav_region)
	for selected_tilemap in selected_tilemaps:
		print_debug("Baking TileMap: %s" % selected_tilemap.name)
		var physics_layers = selected_tilemap.tile_set.get_physics_layers_count()
		for layer in selected_tilemap.get_layers_count():
			print_debug("Baking Layer: %s" % selected_tilemap.get_layer_name(layer))
			var cells = selected_tilemap.get_used_cells(layer)
			for cell in cells:
				var cell_data = selected_tilemap.get_cell_tile_data(layer, cell)
				var cell_pos = selected_tilemap.to_global(selected_tilemap.map_to_local(cell))
				if cell_data != null:
					for physics_layer in physics_layers:
						for polygon_index in cell_data.get_collision_polygons_count(physics_layer):
							var polygon = cell_data.get_collision_polygon_points(physics_layer, polygon_index)
							polygon = GeometryUtils.polygon_to_local(polygon, cell_pos)
							nav_data.add_obstruction_outline(polygon)
	
	print("Obstruction outlines count: $s" % nav_data.obstruction_outlines.size())
	
	NavigationServer2D.bake_from_source_geometry_data_async(selected_nav_region.navigation_polygon, nav_data)
