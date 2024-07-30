extends Control

var generator : float = 0.0
var collected : float = 0.0
var lastTimeCollected : int = 0

# same example as my post: 5000 resource generated in 2 hours
const maxGen : int = 5000
const genPeriod : float = 7200.0
const genPerSec : float = maxGen / genPeriod

const saveFileName : String = "user://resource.dat"
var saveFile : ConfigFile

func _ready():
	saveFile = ConfigFile.new()
	var error = saveFile.load(saveFileName)
	if error == ERR_FILE_NOT_FOUND:
		lastTimeCollected = 0
	else:
		lastTimeCollected = saveFile.get_value("data", "lastTimeCollected", 0)
		collected = saveFile.get_value("data", "collected", 0.0)
	generator = int(Time.get_unix_time_from_system() - lastTimeCollected) * maxGen / genPeriod
	$CenterContainer/HBoxContainer/collected.text = str(int(collected))
	

func _on_button_pressed():
	collected += generator
	generator = 0.0
	$CenterContainer/HBoxContainer/collected.text = str(int(collected))
	lastTimeCollected = Time.get_unix_time_from_system()


func _on_quit_pressed():
	saveFile.set_value("data", "lastTimeCollected", lastTimeCollected)
	saveFile.set_value("data", "collected", collected)
	var error = saveFile.save(saveFileName)
	if error != OK:
		print("Error saving data file:" + str(error))

	get_tree().quit()


func _on_timer_timeout():
	generator += genPerSec
	if generator > maxGen:
		generator = maxGen
	$CenterContainer/HBoxContainer/generator.text = str(int(generator))
