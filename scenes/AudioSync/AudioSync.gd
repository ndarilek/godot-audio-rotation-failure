tool
extends Viewport

func add_audio_node(node):
  if node is AudioStreamPlayer3D:
    node.add_to_group("3d_streams")
  elif node is Listener:
    node.get_parent().add_to_group("3d_listeners")

func add_audio_nodes(node: Node):
  add_audio_node(node)
  for child in node.get_children():
    add_audio_nodes(child)

func _ready():
  get_tree().connect("node_added", self, "add_audio_node")
  add_audio_nodes(get_tree().root)

func sync_audio_to_node2d(audio, node2d: Node2D):
  # print("sync")
  # print("Audio", audio.global_transform)
  # print("Node", node2d.position)
  audio.global_transform.origin.x = node2d.position.x
  audio.global_transform.origin.y = node2d.position.y
  audio.global_transform.origin.z = 0
  var axis = Vector3(0, 0, 1)
  var up = Vector3(0, 0, -1)
  var looking_at = Vector3(1, 0, 0).rotated(axis, node2d.rotation)
  looking_at.x += node2d.global_position.x
  looking_at.y += node2d.global_position.y
  audio.look_at(looking_at, up)

func _physics_process(delta):
  for node in get_tree().get_nodes_in_group("3d_streams"):
    var parent = node.get_parent()
    if parent is Node2D and not parent is RayCast2D:
      sync_audio_to_node2d(node, parent)
  var listeners = get_tree().get_nodes_in_group("listener")
  if listeners and len(listeners) == 1:
    var listener = listeners[0]
    for node in get_tree().get_nodes_in_group("3d_listeners"):
      sync_audio_to_node2d(node, listener)
