class_name Client
extends Connection

var has_actions : Array[bool] = []
var actions : Array[Callable] = []
var _player : HumanPlayer = null
var _server_time_offset := 0
var _best_ping := 0x7FFFFFFF
var _current_ping := 0xFFFF

var local_time: int:
	get: return int(Time.get_unix_time_from_system() * 1000)

var server_time: int:
	get: return local_time + _server_time_offset

func init_actions():
	if actions.size() != 0:
		return
	has_actions.resize(UDP.MAX)
	actions.resize(UDP.MAX)
	add_action(UDP.PING, on_ping)
	add_action(UDP.PONG, on_pong)
	add_action(UDP.CONNECT, on_connect)
	add_action(UDP.NEW_PLAYER, on_new_player)
	add_action(UDP.NEW_CHAR, on_new_char)
	add_action(UDP.START_LEVEL, on_start_level)
	add_action(UDP.SET_TURN, on_set_turn)

func add_action(id: int, action: Callable) -> void:
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
			#print_debug("rcv: "+str(buffer[0]))
			if action >= 0 and action < UDP.MAX and has_actions[action]:
				actions[action].call(buffer.slice(UDP.HEADER_SIZE, buffer.size()))

func new_packet(action: int, size: int) -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(size+UDP.HEADER_SIZE)
	buffer[0] = action
	return buffer

func send(buffer: PackedByteArray):
	udp.put_packet(buffer)


func send_ping():
	var buffer := new_packet(UDP.PING, 4)
	buffer.encode_u32(0, local_time)
	send(buffer)



func on_ping(buf: PackedByteArray) -> void:
	if buf.size() != 4:
		return
	var buffer := new_packet(UDP.PONG, 4)
	encode_copy(buffer, 0, buf, 0, 4)
	send(buffer)

func on_pong(buf: PackedByteArray) -> void:
	if buf.size() < 4:
		return
	var ping := buf.decode_u32(0)
	_current_ping = local_time - ping
	if buf.size() < 8:
		return
	if _current_ping < _best_ping:
		var server_time := buf.decode_u32(4)
		_best_ping = _current_ping
		_server_time_offset = server_time + int(_best_ping/2) - local_time

func on_connect(buf: PackedByteArray) -> void:
	if buf.size() != 1:
		return
	Lobby.main.set_me(buf.decode_u8(0))
	#send_ping()
	if Lobby.main.is_host:
		DebugManager.main.on_connected()

func on_new_player(buf: PackedByteArray) -> void:
	if Lobby.main.is_host or buf.size() != 1:
		return
	var id := buf.decode_u8(0)
	Lobby.main.add_player(id)

func on_new_char(buf: PackedByteArray) -> void:
	if Lobby.main.is_host or buf.size() != 6:
		return
	var chr_id:= buf.decode_u16(0)
	var room_id:= buf.decode_u8(2)
	var slot_id:= buf.decode_u8(3)
	var player_id:= buf.decode_u8(4)
	pass

func on_start_level(buf: PackedByteArray) -> void:
	GameMode.main.on_start_level()

func on_set_turn(buf: PackedByteArray) -> void:
	if buf.size() != 1:
		return
	var id:= buf.decode_u8(0)
	GameMode.main.on_set_turn(id)
