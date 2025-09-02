class_name Client
extends Connection

static var has_actions : Array[bool] = []
static var actions : Array[Callable] = []
var _player : HumanPlayer = null

static func init_actions():
	if actions.size() != 0:
		return
	has_actions.resize(UDP.MAX)
	actions.resize(UDP.MAX)
	add_action(UDP.PONG, on_ping)
	add_action(UDP.PING, on_pong)
	add_action(UDP.CONNECT, on_connect)
	add_action(UDP.PLAYER_ID, on_player_id)
	add_action(UDP.NEW_PLAYER, on_new_player)
	add_action(UDP.NEW_CHAR, on_new_char)

static func add_action(id: int, action: Callable) -> void:
	has_actions[id] = true
	actions[id] = action

func _init(ip: String, port: int) -> void:
	udp = PacketPeerUDP.new()
	init_actions()
	udp.connect_to_host(ip, port)
	try_connect()

func try_connect():
	var id := OS.get_unique_id().to_utf8_buffer()
	var buffer := PackedByteArray()
	buffer.resize(1+1+id.size())
	buffer[0] = UDP.CONNECT
	encode_uft8(buffer, 1, id)
	udp.put_packet(buffer)

func process() -> void:
	while udp.get_available_packet_count() > 0:
		var buffer : PackedByteArray = udp.get_packet()
		if buffer.size() > 0:
			var action = buffer[0]
			if has_actions[action]:
				actions[action].call(self, buffer, 1, buffer.size()-1)

func send_ping():
	var buffer := PackedByteArray()
	buffer.resize(5)
	buffer[0] = UDP.PING
	var time := int(Time.get_unix_time_from_system() * 1000)
	buffer.encode_s32(1, time)
	udp.put_packet(buffer)

static func on_ping(client: Client, buf: PackedByteArray, pos: int, length: int) -> void:
	if length != 4:
		return
	var buffer := PackedByteArray()
	buffer.resize(5)
	buffer[0] = UDP.PONG
	encode_copy(buffer, 1, buf, pos, 4)
	client.udp.put_packet(buffer)

static func on_pong(client: Client, buf: PackedByteArray, pos: int, length: int) -> void:
	pass

static func on_connect(client: Client, buf: PackedByteArray, pos: int, length: int) -> void:
	pass
	#if Lobby.main.is_host:

static func on_player_id(client: Client, buf: PackedByteArray, pos: int, length: int) -> void:
	if length != 2:
		return
	Lobby.main.set_me(buf.decode_u16(pos))

static func on_new_player(client: Client, buf: PackedByteArray, pos: int, length: int) -> void:
	if Lobby.main.is_host or length != 2:
		return
	var id := buf.decode_u16(pos)
	Lobby.main.add_player(id)

static func on_new_char(client: Client, buf: PackedByteArray, pos: int, length: int) -> void:
	if Lobby.main.is_host or length != 7:
		return
	pass
