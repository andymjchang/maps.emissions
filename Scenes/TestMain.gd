extends Control


# Declare member variables here. Examples:
var url = "https://maps.googleapis.com/maps/api/directions/json?origin=%s&destination=%s&mode=%s&key=AIzaSyD2Fca93RM4jzsTIKrdvMBmtBfpqIein-Y"
export var origin = ""
export var dest = ""
export var mode = "driving" # driving or walking

func make_request():
	if(origin == "" || dest == ""):
		return
	origin = origin.replace(" ", "%20")
	dest = dest.replace(" ", "%20")
	var fetchURL = url % [origin, dest, mode]
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
	print("distance", data[0].distance)
	print("duration", data[0].duration)
	print(data[0].steps)


func _on_Starting_text_entered(new_text):
	origin = new_text
	make_request()

func _on_Destination_text_entered(new_text):
	dest = new_text
	make_request()
