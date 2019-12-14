extends Node2D

export var rotation_speed_degrees = 90

var speed = 0

func _process(delta):
  if Input.is_action_just_pressed("speak_coordinates"):
    var x = int(position.x)
    var y = int(position.y)
    y *= -1
    if y == -0:
      y = 0
    TTS.speak("%s, %s" % [x, y], true)
  elif Input.is_action_just_pressed("speak_heading"):
    var degrees = global_rotation_degrees
    TTS.speak("%s degrees" % round(degrees), true)
  elif Input.is_action_pressed("stop_speech"):
    TTS.stop()

func _physics_process(delta):
  var rotation_dir = 0
  if Input.is_action_pressed("ui_left"):
    rotation_dir -= 1
  elif Input.is_action_pressed("ui_right"):
    rotation_dir += 1
  if Input.is_action_pressed("ui_up"):
    speed = delta
  var rotation_delta = rotation_speed_degrees * rotation_dir * delta 
  global_rotation_degrees += rotation_delta
  var velocity = Vector2(speed, 0).rotated(rotation)
  global_position += velocity
