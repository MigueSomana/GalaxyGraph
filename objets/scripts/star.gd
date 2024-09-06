extends TextureButton

var validation = false
var touch_Over = false
var is_Selected = false

#Funcion para detectar si el boton se pisa o se suelta
func _ready():
	connect("button_down", Callable(self, "_on_Pressed"))
	connect("button_up", Callable(self, "_on_Released"))

#Funcion si se presiona
func _on_Pressed():
	get_parent().touching = true
	get_parent().ready_To_Add_Line = true

#Funcion si se suelta
func _on_Released():
	get_parent().touching = false
	touch_Over = false
	for v in get_parent().get_children():
		v.is_Selected = false

#Chequear si se esta sobre el boton
func check_hover(pos):
	if get_global_rect().has_point(pos):
		if !validation:
			validation = true
			touch_Over = true
			if !is_Selected:
				get_parent().ready_To_Add_Line = true
	else:
		validation = false
		touch_Over = false

#Recibir el evento y revisarlo
func _input(event):
	if event is InputEventScreenTouch:
		if !event.pressed:
			validation = false
			for v in get_parent().get_children():
				v.touch_Over = false

#Funcion de godot que se ejecutara en cada frame
func _process(delta):
	if get_parent().touching:
		check_hover(get_parent().touch_Position)
