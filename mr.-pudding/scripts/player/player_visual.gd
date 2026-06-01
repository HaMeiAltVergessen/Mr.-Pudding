class_name PlayerVisual
extends SubViewportContainer

@onready var mesh_instance: MeshInstance3D = $SubViewport/PuddingMesh


func face_direction(direction: float) -> void:
	if direction != 0.0:
		mesh_instance.rotation.y = 0.0 if direction > 0.0 else PI
