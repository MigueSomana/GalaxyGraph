extends Node2D

@onready var this_Level = $"Level 1-E"
var edge = []
var key_level
var complete = [false,false,false,false,false]

# Verificar si se gano o perdio
func win_condition():
	for i in complete:
		if i != true:
			active_star()
			return false
	for s in this_Level.get_children():
		s.get_node("AnimationPlayer").play("RESET")
	return true

# Obtener el centro del boton
func button_centered():
	for s in this_Level.get_children():
		if s.touch_Over :
			return s.get_global_rect().get_center()

#Obtener el boton que se esta pulsando
func get_button_over_itself():
	for s in this_Level.get_children():
		if s.touch_Over:
			return s

#Refrescar cual es el ultimo nodo seleccionado
func refresh_selected():
	for s in this_Level.get_children():
		if s.is_Selected:
			s.is_Selected = false
	get_button_over_itself().is_Selected = true

#Refrescar la lista de ejes o aristas
func refresh_edge():
	edge.clear()
	for i in $Line2D.get_point_count()-2:
		edge.append([conv_pos_to_nod($Line2D.get_point_position(i)),conv_pos_to_nod($Line2D.get_point_position(i+1))])
	for i in key_level.size():
		if key_level[i] == get_grade(i+1):
			complete[i] = true
		else:
			for j in key_level:
				complete[j] = false
			break

#Convertidor de posicion a nodo
func conv_pos_to_nod(p):
	for i in this_Level.get_child_count():
		if p == Vector2(this_Level.get_child(i).global_position.x+40, this_Level.get_child(i).global_position.y+40):
			return i+1
	pass

func get_grade(n):
	var count = 0
	for e in edge:
		for num in e:
			if num == n:
				count += 1
	return count

#Verificar si un nodo existe
func node_exists():
	var comparator = Vector2.ZERO
	var check = 0
	for s in this_Level.get_children():
		if s.is_Selected:
			comparator=Vector2(s.global_position.x+40,s.global_position.y+40)
	if $Line2D.get_point_count() > 1:
		for p in $Line2D.get_points():
			if p == button_centered() or p == comparator:
				check+=1
			elif check>1:
				return false
			else:
				check=0
		return true
	return true

func active_star():
	for s in this_Level.get_children():
		s.get_node("AnimationPlayer").play("MOVE")
		await get_tree().create_timer(0.05).timeout

#Funcion que dibuja la linea
func line_function():
	if this_Level.touching == true:
		if this_Level.ready_To_Add_Line == true:
			if button_centered():
				if $Line2D.get_point_count() == 0:
					$Line2D.add_point(button_centered() ,-1)
					#$"GPUParticles2D".position = this_Level.touch_Position
					#$"GPUParticles2D".visible= true
				if get_button_over_itself().is_Selected != true and node_exists():
					$Line2D.add_point(button_centered(),-1)
					get_button_over_itself().get_node("AnimationPlayer").play("TOUCH")
					$Line2D.set_point_position($Line2D.get_point_count()-2, button_centered())
					#$"GPUParticles2D".position = this_Level.touch_Position
					refresh_selected()
		#Que sigan el deslizar
		if $Line2D.get_point_count() > 0:
			$Line2D.set_point_position($Line2D.get_point_count()-1, this_Level.touch_Position)
			#$"GPUParticles2D".position = this_Level.touch_Position
	else:
		#Borrar todo si se suelta
		if $Line2D.get_point_count() > 0:
			#$"GPUParticles2D".position = Vector2(-1000,-1000)
			#$"GPUParticles2D".visible= false
			refresh_edge()
			win_condition()
		$Line2D.clear_points()

#Funcion de godot que se ejecutara en cada frame
func _process(delta):
	line_function()
	queue_redraw()
	
func _ready():
	key_level= this_Level.key_level
	active_star()
