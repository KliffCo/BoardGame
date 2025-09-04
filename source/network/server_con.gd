class_name ServerCon
extends Connection

static var has_actions : Array[bool] = []
static var actions : Array[Callable] = []
var player : HumanPlayer = null
static var _server_time:= 0

static func update_time() -> void:
	_server_time = int(Time.get_unix_time_from_system() * 1000)

static var server_time: int:
	get: return _server_time

static func init_actions():
	if actions.size() != 0:
		return
	has_actions.resize(UDP.MAX)
	actions.resize(UDP.MAX)
	add_action(UDP.PING, on_ping)
	add_action(UDP.PONG, on_pong)
	#add_action(UDP.CONNECT, on_connect)

static func add_action(id: int, action: Callable) -> void:
	has_actions[id] = true
	actions[id] = action

func _init(_udp: PacketPeerUDP, _player: HumanPlayer) -> void:
	update_time()
	udp = _udp
	player = _player
	player.con = self

func process() -> void:
	update_time()
	while udp.get_available_packet_count() > 0:
		var buffer : PackedByteArray = udp.get_packet()
		if buffer.size() > 0:
			var action = buffer[0]
			if action >= 0 and action < UDP.MAX and has_actions[action]:
				actions[action].call(self, buffer.slice(UDP.HEADER_SIZE, buffer.size()))

func new_packet(action: int, size: int) -> PackedByteArray:
	var buffer := PackedByteArray()
	buffer.resize(size+UDP.HEADER_SIZE)
	buffer[0] = action
	return buffer

func send(buffer: PackedByteArray):
	#print_debug("snd: "+str(buffer[0]))
	udp.put_packet(buffer)



func send_connect() -> void:
	var buffer := new_packet(UDP.CONNECT, 1)
	buffer.encode_u8(UDP.HEADER_SIZE, player.id)
	send(buffer)

func send_new_player(p: Player) -> void:
	var buffer := new_packet(UDP.NEW_PLAYER, 6)
	buffer.encode_u16(UDP.HEADER_SIZE, p.id)
	send(buffer)

func send_new_char(chr: Char) -> void:
	var buffer := new_packet(UDP.NEW_CHAR, 6)
	buffer.encode_u16(UDP.HEADER_SIZE+0, chr.id)
	buffer.encode_u8(UDP.HEADER_SIZE+2, chr.room.id)
	buffer.encode_u8(UDP.HEADER_SIZE+3, chr.slot.id)
	buffer.encode_u16(UDP.HEADER_SIZE+4, chr.player_id)
	send(buffer)

func send_my_chars() -> void:
	var chars := player.get_my_chars()
	var buffer := new_packet(UDP.CHAR_PLAYER_IDS, chars.size() * 2)
	var i := UDP.HEADER_SIZE
	for c in chars:
		if c.player_id == player.id:
			buffer.encode_u8(i, c.id)
			buffer.encode_u8(i+1, player.id)
			i += 2
	send(buffer)

func send_start_level() -> void:
	var buffer := new_packet(UDP.START_LEVEL, 0)
	send(buffer)

func send_set_turn(id: int) -> void:
	var buffer := new_packet(UDP.SET_TURN, 1)
	buffer.encode_u8(UDP.HEADER_SIZE, id)
	send(buffer)



static func on_ping(con: ServerCon, buf: PackedByteArray) -> void:
	if buf.size() != 4:
		return
	var buffer := con.new_packet(UDP.PONG, 8)
	encode_copy(buffer, 0, buf, 0, 4)
	buffer.encode_s32(4, server_time)
	con.send(buffer)

static func on_pong(_con: ServerCon, _buf: PackedByteArray) -> void:
	pass
