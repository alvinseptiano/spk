extends Panel

var bobot = [25, 15, 30, 25, 5]
var tipe = [0, 1, 0, 1, 1]
#var bobot = [40, 30, 30]
#var tipe = [0, 1, 0]


func _ready() -> void:
	$H/V/H2/BobotKriteria.pressed.connect(_on_bobot_switched)


func add_bobot(is_using_example: bool = false) -> void:
	var jumlah_kriteria = $H/V/H/ColorRect/H/V/JumlahKriteria/Value.value
	if is_using_example:
		jumlah_kriteria = bobot.size()
	if $H/V/H2/ScrollContainer/H.get_child_count() > 0:
		for node in $H/V/H2/ScrollContainer/H.get_children():
			node.queue_free()
	
	await get_tree().process_frame
	for i in jumlah_kriteria:
		var node = preload("res://Bobot.tscn").instantiate()
		node.name = "C" + str(i + 1)
		node.get_node("Label").text = "C" + str(i + 1)
		if is_using_example:
			node.get_node("Tipe").selected = tipe[i]
		node.get_node("Nilai").value = 0
		if is_using_example:
			node.get_node("Nilai").value = bobot[i]
		$H/V/H2/ScrollContainer/H.add_child(node)


func get_bobot() -> Array:
	var arr: Array
	for node in $H/V/H2/ScrollContainer/H.get_children():
		arr.append(node.get_node("Nilai").value)
	return arr


func get_bobot_type() -> Array:
	var arr: Array
	for node in $H/V/H2/ScrollContainer/H.get_children():
		var selected = node.get_node("Tipe").selected
		arr.append(node.get_node("Tipe").get_item_text(selected))
	return arr


func _on_bobot_switched() -> void:
	$H/V/H2/ScrollContainer.visible = false
	if $H/V/H2/BobotKriteria.button_pressed:
		$H/V/H2/ScrollContainer.visible = true

