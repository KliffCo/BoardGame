class_name ServerCon
extends Connection

static var has_actions : Array[bool] = []
static var actions : Array[Callable] = []
var player : HumanPlayer = null

static func init_actions():
	if actions.size() != 0:
		return
	has_actions.resize(UDP.MAX)
	actions.resize(UDP.MAX)
	#add_action(UDP.PONG, on_ping)
	#add_action(UDP.PING, on_pong)
	#add_action(UDP.CONNECT, on_connect)

static func add_action(id: int, action: Callable) -> void:
	has_actions[id] = true
	actions[id] = action

func _init(_udp: PacketPeerUDP, _player: HumanPlayer) -> void:
	udp = _udp
	player = _player
	player.con = self

func process() -> void:
	while udp.get_available_packet_count() > 0:
		var buffer : PackedByteArray = udp.get_packet()
		if buffer.size() > 0:
			var action = buffer[0]
			if has_actions[action]:
				actions[action].call(self, buffer, 1, buffer.size()-1)

func _new_packet(size: int) -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(size)
	return buffer

func _send(buffer: PackedByteArray):
	udp.put_packet(buffer)

func send_connect() -> void:
	var buffer := _new_packet(3)
	buffer[0] = UDP.CONNECT
	buffer.encode_u16(1, player.id)
	_send(buffer)

func send_new_player(p: Player) -> void:
	var buffer := _new_packet(7)
	buffer[0] = UDP.NEW_CHAR
	buffer.encode_u16(1, p.id)
	_send(buffer)

func send_new_char(chr: Char) -> void:
	var buffer := _new_packet(7)
	buffer[0] = UDP.NEW_CHAR
	buffer.encode_u16(1, chr.id)
	buffer.encode_u8(3, chr.room.id)
	buffer.encode_u8(4, chr.slot.id)
	buffer.encode_u16(5, chr.player_id)
	_send(buffer)

func send_my_chars() -> void:
	var chars := player.get_my_chars()
	var buffer := _new_packet(1 + chars.size() * 4)
	buffer[0] = UDP.CHAR_PLAYER_IDS
	var i := 1
	for c in chars:
		if c.player_id == player.id:
			buffer.encode_u16(i, c.id)
			buffer.encode_u16(i+2, player.id)
			i += 4
	_send(buffer)

static func on_ping(client: ServerCon, buf: PackedByteArray, pos: int, length: int) -> void:
	if length != 4:
		return
	var buffer := PackedByteArray()
	buffer.resize(5)
	buffer[0] = UDP.PONG
	encode_copy(buffer, 1, buf, pos, 4)
	client.udp.put_packet(buffer)

static func on_pong(client: ServerCon, buf: PackedByteArray, pos: int, length: int) -> void:
	pass

static func on_connect(client: ServerCon, buf: PackedByteArray, pos: int, length: int) -> void:
	pass
