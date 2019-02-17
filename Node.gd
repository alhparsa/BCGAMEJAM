extends Node

onready var _log_dest = get_parent().get_node("Panel/VBoxContainer/RichTextLabel")

var _server = WebSocketServer.new()
var _write_mode = WebSocketPeer.WRITE_MODE_TEXT
var _use_multiplayer = true
var last_connected_client = 0
var _clients = {}
func _init():
 	_server.connect("client_connected", self, "_client_connected")
 	_server.connect("client_disconnected", self, "_client_disconnected")
 	_server.connect("client_close_request", self, "_client_close_request")
 	_server.connect("data_received", self, "_client_receive")
 	_server.connect("peer_packet", self, "_client_receive")
 	_server.connect("peer_disconnected", self, "_client_disconnected")

func _ready():
	_server.listen(7200)


func _exit_tree():
	_clients.clear()
	_server.stop()

func _process(delta):
	if _server.is_listening():
		_server.poll()


func _client_connected(id, protocol):
	_clients[id] = _server.get_peer(id)
	_clients[id].set_write_mode(_write_mode)
	last_connected_client = id

func _client_disconnected(id, clean):
	if _clients.has(id):
 		_clients.erase(id)

func _client_receive(id):
	var packet = _server.get_peer(id).get_packet()
	print (packet.get_string_from_utf8())

func send_data(choice):
	_server.get_peer(1).put_packet(choice)


func stop():
	_server.stop()

