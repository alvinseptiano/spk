extends VBoxContainer

const slot_path = "res://DataSlot.tscn"
const sub_judul = "res://DataRowColumn.tscn"

@onready var kriteria = $H/Grid/Kriteria
@onready var alternatif = $H/Grid/Alternatif
@onready var content = $H/Grid/Content


func refresh_table(value: Array, column: int, row: int) -> void:
	for node in $H/Result/V/Content.get_children():
		node.free()
	for node in $H/Result/V/Rank.get_children():
		node.free()
	for node in $H/Equal.get_children():
		if not node.name == "Control":
			node.free()

	for node in $H/Grid/Kriteria.get_children():
		node.free()
	for node in $H/Grid/Alternatif.get_children():
		node.free()
	for node in content.get_children():
		node.free()
	content.columns = column

	for i in row:
		var row_node = preload(sub_judul).instantiate()
		row_node.name = str(i + 1)
		row_node.text = "A" + str(i + 1)
		$H/Grid/Alternatif.add_child(row_node)
		var node = preload("res://Equal.tscn").instantiate()
		$H/Equal.add_child(node)
	for i in column:
		var column_node = preload(sub_judul).instantiate()
		column_node.name = str(i + 1)
		column_node.text = "C" + str(i + 1)
		$H/Grid/Kriteria.add_child(column_node)
	await get_tree().process_frame

	var n = 0
	for x in row:
		for y in column:
			var node = preload(slot_path).instantiate()
			node.name = str(x + 1) + "-" + str(y + 1) # Beri nama berdasarkan koordinat
			node.value = value[n]
			content.add_child(node)
			n += 1

	n = 0
	for x in range(2):
		for y in row:
			var node = preload(slot_path).instantiate()
			node.name = str(x + 1) + "-" + str(y + 1)
			node.value = value[n]

	n = 0
	var arr: Array
	for y in range(row): 
		arr.append([])
		arr[y].resize(column)
		for x in range(column):
			arr[y][x] = value[n]
			if n < value.size():
				n += 1
	var arr_i = 0
	n = 0
	var sum: float
	for y in row:
		sum = 0
		for x in column:
			sum += arr[y][x]
		var node = preload(slot_path).instantiate()
		node.value = snapped(sum, 0.01)
		$H/Result/V/Content.add_child(node)
		n += 1
	var result: Array
	var rank: Array

	for i in $H/Result/V/Content.get_children():
		result.append(float(i.value))

	result.sort()
	rank.resize(result.size())
	var x: int = result.size() - 1
	var r = 1
	while x > -1:
		n = 0
		for i in $H/Result/V/Content.get_children():
			if float(i.value) == result[x]:
				rank[n] = r
				r += 1
				x -= 1
				if x < 0:
					break
			n += 1

	for i in result.size():
		print(rank)
		var node = preload(slot_path).instantiate()
		node.value = rank[i]
		$H/Result/V/Rank.add_child(node)
