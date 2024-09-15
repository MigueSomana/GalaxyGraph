extends Node2D

var touching = false
var ready_To_Add_Line = false
var touch_Position = null
var key_level= [4,4,4,4,4]

#Verificar si se esta tocando y mandar posicion
func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_Position = event.position
		else:
			touching = false
	if event is InputEventScreenDrag:
		touch_Position = event.position
