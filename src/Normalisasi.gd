extends VBoxContainer

const slot_path = "res://DataSlot.tscn"
const sub_judul = "res://DataRowColumn.tscn"

@onready var kriteria = $Grid/Kriteria
@onready var alternatif = $Grid/Alternatif
@onready var content = $Grid/Content


func refresh_table(value: Array, column: int, row: int) -> void:
	for node in $Grid/Kriteria.get_children():
		node.queue_free()
	for node in $Grid/Alternatif.get_children():
		node.queue_free()
	for node in content.get_children():
		node.queue_free()
	
	content.columns = column

	for i in row:
		var row_node = preload(sub_judul).instantiate()
		row_node.name = str(i + 1)
		row_node.text = "A" + str(i + 1)
		$Grid/Alternatif.add_child(row_node)
	for i in column:
		var column_node = preload(sub_judul).instantiate()
		column_node.name = str(i + 1)
		column_node.text = "C" + str(i + 1)
		$Grid/Kriteria.add_child(column_node)
	await get_tree().process_frame
	var n = 0
	for x in row:
		for y in column:
			var node = preload(slot_path).instantiate()
			node.name = str(x + 1) + "-" + str(y + 1) # Beri nama berdasarkan koordinat
			node.value = value[n]
			content.add_child(node)
			n += 1
