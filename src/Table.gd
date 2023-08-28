extends VBoxContainer

const slot_path = "res://DataSlot.tscn"
const sub_judul = "res://DataRowColumn.tscn"

var data: Array
var n_column : int
var n_row: int
var data_coordinate: Dictionary
#var example_data = [
#	1, 2, 3,
#	4, 5, 6
#
#]
var example_data = [
	150, 15, 2, 2, 3,
	500, 200, 2, 3, 2,
	200, 10, 3, 1, 3,
	350, 100, 3, 1, 2
	]

func _ready() -> void:
	n_column = get_column()
	n_row = get_row()


func resize(width: int, height: int) -> void:
	n_column = width
	n_row = height

	var total = n_column * n_row
	var value: Dictionary
	var coordinate: String
	
	for y in n_column:
		for x in n_row:
			coordinate = str(x + 1) + "-" + str(y + 1) 
			if has_node("Grid/Content/"  + coordinate):
				data_coordinate[coordinate] = get_node("Grid/Content/"  + coordinate).value

	for node in $Grid/Kriteria.get_children():
		node.free()
	for node in $Grid/Alternatif.get_children():
		node.free()
	for node in $Grid/Content.get_children():
		node.free()
	await get_tree().process_frame
	
	for i in n_row:
		var column_node = preload(sub_judul).instantiate()
		column_node.name = str(i + 1)
		column_node.text = "A" + str(i + 1)
		$Grid/Alternatif.add_child(column_node)
	for y in n_column:
		var row_node = preload(sub_judul).instantiate()
		row_node.name = str(y + 1)
		row_node.text = "C" + str(y + 1)
		$Grid/Kriteria.add_child(row_node)

	$Grid/Content.columns = width
	var keys = data_coordinate.keys()
	print(JSON.stringify(data_coordinate, "\t"))

	var n = 0
	for x in n_row:
		for y in n_column:
			var node = preload(slot_path).instantiate()
			coordinate = str(x + 1) + "-" + str(y + 1)
			if data_coordinate.has(coordinate):
				node.value = data_coordinate[coordinate]
#			else:
#				node.value_changed
			node.name = coordinate
			$Grid/Content.add_child(node) 


func create_2d_array(
			width: int, height: int, get_by_column: bool, value: Array
	) -> Array:
	var arr = []
	var size = value.size()
	var n: int 
	var column_arr: Array
	print("before ",  value)
	for y in range(height):
			column_arr.append([])
			column_arr[y].resize(width)
			for x in range(width):
				if n < size:
					column_arr[y][x] = value[n]
				n += 1

	if get_by_column:
		for y in n_column:
			arr.append([])
			for x in n_row:
				arr[y].append(column_arr[x][y])
	return arr


func get_total(get_by_column: bool) -> Array:
	var total: Array
	get_column()
	get_row()
	var coordinate: String
	if get_by_column:
		for x in n_row:
			for y in n_column:
				coordinate = str(x + 1) + "-" + str(y + 1) 
				var get_value: float
				if has_node("Grid/Content/"  + coordinate):
					get_value = int(get_node("Grid/Content/"  + coordinate).value)
					total.append(get_value)
				data_coordinate[coordinate] = get_value
	data = total
	if get_by_column:
		data = create_2d_array(n_column, n_row, true, total)
	return data


func get_column() -> int:
	n_column = $Grid/Content.columns
	return n_column


func get_row() -> int:
	n_row = $Grid/Content.get_child_count() / $Grid/Content.columns
	return n_row


func clear() -> void:
	data_coordinate.clear()


func check_for_empty_table() -> bool:
	var arr: Array
	for node in $Grid/Content.get_children():
		if node.value == 0 or node.value == null:
			arr.append(true)
	if true in arr:
		return true
	return false


func clear_node() -> void:
	for node in $Grid/Kriteria.get_children():
		node.free()
	for node in $Grid/Alternatif.get_children():
		node.free()
	for node in $Grid/Content.get_children():
		node.free()
	await get_tree().process_frame


func example(value: Array, is_using_example: bool = false) -> void:
	var amount = value[0] * value[1]
	n_column = value[0]
	n_row = value[1]
	var n = 0
	$Grid/Content.columns = int(value[0])

	for node in $Grid/Kriteria.get_children():
		node.free()
	for node in $Grid/Alternatif.get_children():
		node.free()
	for node in $Grid/Content.get_children():
		node.free()
	await get_tree().process_frame

	for i in n_row:
		var column_node = preload(sub_judul).instantiate()
		column_node.name = str(i + 1)
		column_node.text = "A" + str(i + 1)
		$Grid/Alternatif.add_child(column_node)
	for y in n_column:
		var row_node = preload(sub_judul).instantiate()
		row_node.name = str(y + 1)
		row_node.text = "C" + str(y + 1)
		$Grid/Kriteria.add_child(row_node)
	var num
	var arr_name = []
	for x in n_row:
		for y in n_column:
			var coordinate = str(x + 1) + "-" + str(y + 1) 
			var node = preload(slot_path).instantiate()
			arr_name.append(coordinate)
			node.name = coordinate.replace("@", "")
			node.get_node("Label").text = coordinate
			if is_using_example:
				if n >= example_data.size():
					break
				node.value = example_data[n]
			else:
				node.value = data[n]
			n += 1
			$Grid/Content.add_child(node)
