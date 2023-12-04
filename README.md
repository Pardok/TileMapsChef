# TileMapsChef
<img width="96" alt="TileMapsChef icon" src="https://github.com/Pardok/TileMapsChef/assets/16256469/fcd6dbf9-8f63-4f0e-8549-919db74e886e">

Godot plugin to add some functionality to TileMaps

## Usage

### Baking NavigationPolygon from multiple layers of TileMap(s)
This solves issue with Godot's 4.2 baking of TileMaps. If any of you colliders not on `Layer0` of `TileMap`, they will be ignored. This tool scraps all tiles from all the layers (both tile layers and physics layers) and merges as obstructions.
Select `NavigationRegion2D` first, then hold <kbd>Ctrl</kbd> (or <kbd>⌘ Command</kbd> on Mac) and select any amount of `TileMap`s. On the bottom bar TileChef menu should appear, click it. You will see "Bake NavigationPolygon from TileMaps" button. Click it, polygon should be baked. For some reason it waits for you to switch focus to render your polygon in view, so just click on any node or switch to Output to see your polygons baked.

<table>
  <tr>
    <td>
      <img width="1512" alt="Without TileMapsChef" src="https://github.com/Pardok/TileMapsChef/assets/16256469/c5c6dbc8-eeb7-436e-857b-2adb305495a5">
    </td>
    <td>
      <img width="1512" alt="With TileMapsChef" src="https://github.com/Pardok/TileMapsChef/assets/16256469/b49fa375-0ba2-4544-b282-68001da61e2a">
    </td>
  </tr>
  <tr>
    <td>Using built-in baking</td>
    <td>Using TileMapsChef's baking</td>
  </tr>
</table>
