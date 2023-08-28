extends Control

signal refresh_table(value)

var kriteria_amount: int
var alternatif_amount: int

var color_bg_dark := Color(40, 42, 54)
var color_fg_dark := Color(98, 114, 164)
var color_bg_light := Color(248, 248, 242)
var color_fg_light := Color(68, 71, 90)

@onready var tabel = $V/ScrollContainer/Flow/Tabel
@onready var normalisasi = $V/ScrollContainer/Flow/Normalisasi
@onready var ranking = $V/ScrollContainer/Flow/Ranking
@onready var jumlah_kriteria = $AddElement/H/V/H/ColorRect/H/V/JumlahKriteria/Value
@onready var jumlah_alternatif = $AddElement/H/V/H/ColorRect/H/V/JumlahAlternatif/Value
@onready var content = $V/ScrollContainer/Flow/Tabel/Grid/Content


func _ready() -> void:
	$AddElement/H/V/H/ColorRect/H/Resize.pressed.connect(_on_resize_pressed)
	$AddElement/H/V/H/ColorRect/H/Clear.pressed.connect(_on_clear_pressed)
	$AboutMe.pressed.connect(_on_about_pressed)
	$About/VBoxContainer/Close.pressed.connect(_on_about_pressed)
	$AddElement/H/V/H/H2/Contoh.pressed.connect(_on_contoh_pressed)
	$AddElement/H/V2/Hitung.pressed.connect(calculate)
	$AddElement/H/V/H/ColorRect/H/V/JumlahAlternatif/Value.value_changed.connect(_disable_hitung)
	$AddElement/H/V/H/ColorRect/H/V/JumlahKriteria/Value.value_changed.connect(_disable_hitung)
	$WarningPopup.gui_input.connect(_on_gui_input)
	$V/ScrollContainer/Flow/Normalisasi.hide()
	$V/ScrollContainer/Flow/Ranking.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			$WarningPopup.hide()


func calculate() -> void:
	if $V/ScrollContainer/Flow/Tabel.check_for_empty_table():
		$WarningPopup.show()
		return
	var column = $V/ScrollContainer/Flow/Tabel.n_column
	var row = $V/ScrollContainer/Flow/Tabel.n_row
	var result_normalisasi: Array
	var result_ranking: Array
	var value_column = []
	var arr_bobot = $AddElement.get_bobot()
	var bobot_type: Array = $AddElement.get_bobot_type()
	var value = $V/ScrollContainer/Flow/Tabel.get_total(true)
	var size = value.size()
	$V/ScrollContainer/Flow/Normalisasi.show()
	$V/ScrollContainer/Flow/Ranking.show()

	# NORMALISASI DATA
	for y in row:
		for x in column:
			var max = value[x].max()
			var min = value[x].min()
			var n: float
			if bobot_type[x] == "Benefit":
				n = snapped(value[x][y] / max, 0.01)
			elif bobot_type[x] == "Cost":
				n = snapped(min / value[x][y], 0.01)
			result_normalisasi.append(n)

	# RANKING DATA
	var arr_i = 0
	var n = 0
	for y in row:
		n = 0
		for x in column:
			var bobot = arr_bobot[n]
			var multiply = snapped(result_normalisasi[arr_i] * (bobot / 100), 0.01)
			result_ranking.append(multiply)
			arr_i += 1
			n += 1

	normalisasi.refresh_table(
			result_normalisasi, tabel.get_column(), tabel.get_row())
	ranking.refresh_table(
			result_ranking, tabel.get_column(), tabel.get_row())


func create_2d_array(width: int, height: int, value) -> Array:
	var a = []
	for y in range(height):
		a.append([])
		a[y].resize(width)
		for x in range(width):
			a[y][x] = value
	return a


func _on_resize_pressed() -> void:
	$V/ScrollContainer/Flow/Normalisasi.hide()
	$V/ScrollContainer/Flow/Ranking.hide()
	$AddElement/H/V/H/ColorRect/H/Resize.modulate = Color.WHITE
	$AddElement/H/V2/Hitung.disabled = false
	$AddElement.add_bobot(false)
	get_kriteria_and_alternatif()
	$V/ScrollContainer/Flow/Tabel.call_deferred("resize", kriteria_amount, alternatif_amount)


func _on_contoh_pressed() -> void:
	$V/ScrollContainer/Flow/Normalisasi.hide()
	$V/ScrollContainer/Flow/Ranking.hide()
	$AddElement/H/V2/Hitung.disabled = false
	$AddElement/H/V/H/ColorRect/H/V/JumlahKriteria/Value.value = 5
	$AddElement/H/V/H/ColorRect/H/V/JumlahAlternatif/Value.value = 4
	$AddElement.add_bobot(true)
	get_kriteria_and_alternatif()
	$AddElement/H/V2/Hitung.disabled = false
	$AddElement/H/V/H/ColorRect/H/Resize.modulate = Color.WHITE
	#$V/ScrollContainer/Flow/Tabel.resize()
	$V/ScrollContainer/Flow/Tabel.example([kriteria_amount, alternatif_amount], true)


func get_kriteria_and_alternatif() -> void:
	alternatif_amount = $AddElement/H/V/H/ColorRect/H/V/JumlahAlternatif/Value.value
	kriteria_amount =  $AddElement/H/V/H/ColorRect/H/V/JumlahKriteria/Value.value


func _disable_hitung(_value) -> void:
	$AddElement/H/V/H/ColorRect/H/Resize.modulate = Color.YELLOW
	$AddElement/H/V2/Hitung.disabled = true


func _on_clear_pressed() -> void:
	$V/ScrollContainer/Flow/Normalisasi.hide()
	$V/ScrollContainer/Flow/Ranking.hide()
	for node in $V/ScrollContainer/Flow/Tabel/Grid/Content.get_children():
		node.value = 0


func _on_about_pressed() -> void:
	print("About me")
	
	if $About.visible:
		$About.hide()
	else:
		$About.show()
