extends Control


# Declare member variables here. Examples:
const CO2 = 8.887
const BASE_OUTPUT = """DRIVING

Distance: %.2f km or %.2f mi
Time: %s
Carbon Emission: %.4f kg
Twice a Day, 5 Times a Week: %.4f kg"""
const URL = "https://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&mode=%s&key=AIzaSyD2Fca93RM4jzsTIKrdvMBmtBfpqIein-Y"
const FAILED = "Something was invalid in your input, try again"
var origin = ""
var dest = ""
var mode = "driving" # driving or walking
var dragging = false
var fuel_economy = 35.4
var WALKING_OUTPUT = BASE_OUTPUT.replace("DRIVING", "WALKING")
var request_in_progress = false

func _process(delta):
	if(dragging): # Performance
		$SliderVal.text = str($HSlider.value) + ' mpg'

func make_request():
	if(origin == "" || dest == "" || request_in_progress):
		return
	fuel_economy = $HSlider.value
	origin = origin.replace(" ", "%20")
	dest = dest.replace(" ", "%20")
	mode = "driving"
	var fetchURL = URL % [origin, dest, mode]
	$RequestDriving.request(fetchURL, ["method: GET"])

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		$DrivingOutputLabel.text = FAILED
		return
	var json = JSON.parse(body.get_string_from_utf8())
	json = json.result
	if(json.status == "NOT_FOUND"):
		$DrivingOutputLabel.text = FAILED
		return
	var data = json.routes[0].legs
	
	var distance_km = data[0].distance.value / 1000
	var distance_mi = distance_km / 1.61
	var time = data[0].duration.text
	var emissions = CO2 * distance_km / fuel_economy
	$DrivingOutputLabel.text = BASE_OUTPUT % [distance_km, distance_mi, time, emissions, emissions * 2 * 5]

	
func request_walking():
	mode = "walking"
	var fetchURL = URL % [origin, dest, mode]
	$RequestWalking.request(fetchURL, ["method: GET"])

func _on_RequestWalking_request_completed(result, response_code, headers, body):
	request_in_progress = false
	if response_code != 200:
		$DrivingOutputLabel.text = FAILED
		return
	var json = JSON.parse(body.get_string_from_utf8())
	json = json.result
	if(json.status == "NOT_FOUND"):
		$DrivingOutputLabel.text = FAILED
		return
	var data = json.routes[0].legs
	
	var distance_km = data[0].distance.value / 1000
	var distance_mi = distance_km / 1.61
	var time = data[0].duration.text
	var emissions = 0
	$WalkingOutputLabel.text = WALKING_OUTPUT % [distance_km, distance_mi, time, emissions, 0]



func _on_Starting_text_entered(new_text):
	origin = new_text
	dest = $Destination.text
	make_request()

func _on_Destination_text_entered(new_text):
	dest = new_text
	origin = $Starting.text
	make_request()

func _on_HSlider_drag_ended(value_changed):
	dragging = false
	make_request()

func _on_HSlider_drag_started():
	dragging = true
