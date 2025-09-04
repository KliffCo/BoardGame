class_name Server

const PORT = 10050

var has_actions : Array[bool] = []
var actions : Array[Callable] = []
var server: UDPServer = null
var peers: Array[ServerCon] = []

func _init() -> void:
	init_actions()
	ServerCon.init_actions()
	server = UDPServer.new()
	server.listen(PORT)

func init_actions():
	if actions.size() != 0:
		return
	has_actions.resize(UDP.INSTANT)
	actions.resize(UDP.INSTANT)
	add_action(UDP.PONG, on_ping)
	add_action(UDP.CONNECT, on_connect)

func add_action(id: int, action: Callable) -> void:
	has_actions[id] = true
	actions[id] = action

func process() -> void:
	server.poll()
	while server.is_connection_available():
		var udp := server.take_connection()
		process_udp(udp)
	for p in peers:
		p.process()

func process_udp(udp: PacketPeerUDP) -> void:
	while udp.get_available_packet_count() > 0:
		var buffer : PackedByteArray = udp.get_packet()
		if buffer.size() > 0:
			var action = buffer[0]
			if action >= 0 and action < UDP.INSTANT and has_actions[action]:
				actions[action].call(udp, buffer.slice(1, buffer.size()))

func all_peers(action: Callable) -> void:
	for p in peers:
		action.call(p)

func on_ping(udp: PacketPeerUDP, buf: PackedByteArray) -> void:
	if buf.size() != 4:
		return
	var buffer := PackedByteArray()
	buffer.resize(5)
	buffer[0] = UDP.PONG
	Connection.encode_copy(buffer, 1, buf, 0, 4)
	udp.put_packet(buffer)

func on_connect(udp: PacketPeerUDP, buf: PackedByteArray) -> void:
	var player := Lobby.main.add_human()
	var con := ServerCon.new(udp, player)
	for p in peers:
		p.send_new_player(player)
	peers.append(con)
	con.send_connect()
	for p in Lobby.main.players:
		con.send_new_player(p)
	#for c in CharManager.main.chars:
		#con.send_new_char(c)
	#con.send_my_chars()
