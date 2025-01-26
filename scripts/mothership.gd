extends Enemy

@onready var beamer_container = $BeamerContainer

var beamer_scenes
signal boss_killed


func _ready() -> void:
	beamer_scenes = beamer_container.get_children()
	

func _process(delta) -> void:
	position = position.move_toward(Vector2(position.x, 150), speed*delta)

func die():
	for beamer in beamer_scenes:
		print("working on beamer here")
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = CircleShape2D.new()
		collision_shape.shape.radius = 40
		collision_shape.position = Vector2.ZERO
		
		beamer.add_child(collision_shape)
	
	boss_killed.emit(points, self)
