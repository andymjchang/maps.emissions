extends Control


# Declare member variables here. Examples:
const CO2 = 8.887
const FUEL_ECONOMY = 35.4 # TODO: Make this an inputtable value
const URL = "https://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&mode=%s&key=AIzaSyD2Fca93RM4jzsTIKrdvMBmtBfpqIein-Y"
var origin = ""
var dest = ""
var mode = "driving" # driving or walking

func make_request():
	if(origin == "" || dest == ""):
		return
	origin = origin.replace(" ", "%20")
	dest = dest.replace(" ", "%20")
	var fetchURL = URL % [origin, dest, mode]
	$HTTPRequest.request(fetchURL, ["method: GET"])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print("bruh")
		return
	var json = JSON.parse(body.get_string_from_utf8())
	json = json.result
	var data = json.routes[0].legs
	
	var distance_km = data[0].distance.value
	var emissions = CO2 * distance_km / FUEL_ECONOMY
	print(emissions)


func _on_Starting_text_entered(new_text):
	origin = new_text
	dest = $Destination.text
	make_request()

func _on_Destination_text_entered(new_text):
	dest = new_text
	origin = $Starting.text
	make_request()
