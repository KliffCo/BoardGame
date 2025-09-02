class_name Connection

var udp : PacketPeerUDP = null

static func encode_string(dst: PackedByteArray, pos: int, value: String) -> int:
	return encode_uft8(dst, pos, value.to_utf8_buffer())

static func encode_uft8(dst: PackedByteArray, pos: int, src: PackedByteArray) -> int:
	var length := src.size()
	dst[pos] = length
	pos += 1
	for i in range(length):
		dst[pos + i] = src[i]
	return pos + length

static func encode_copy(dst: PackedByteArray, dst_pos: int, src: PackedByteArray, src_pos: int, length: int) -> void:
	for i in range(length):
		dst[dst_pos + i] = src[src_pos + i]

static func decode_string(buf: PackedByteArray, pos) -> String:
	var length: int = buf[pos]
	pos += 1
	var bytes := buf.slice(pos, pos+length)
	return bytes.get_string_from_utf8()
