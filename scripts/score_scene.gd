extends Node

var config = charger_env()
var API_KEY =  get_config("SUPABASE_API_KEY")
var	URL = get_config("SUPABASE_URL")
var header := PackedStringArray([
	"apikey: "+API_KEY,
	"Content-Type: application/json"]) 
var server_result = {"data" : [], "error" : ""}
var highest_score : int
var user : String
var error_label : Label
signal error

func entry_gestion() :
	for enfant in $GridContainer.get_children() : $GridContainer.remove_child(enfant)
	$GridContainer.hide()
	$TextEdit.hide()
	user = $TextEdit.text
	server_result["data"] = []
	make_request("/player?select=name,highest_score&"+"name=eq."
			+user +"&"+"limit=1",
			_on_request_completed_when_entry_gestion)
		

func end_game_gestion(score : int) :
	$GridContainer.show()
	if score > highest_score :
		highest_score = score
		make_request("/player?name=eq."+user,_on_request_completed_when_new_highest_score,{"highest_score" : score},HTTPClient.METHOD_PATCH)
	make_request("/player?select=name,highest_score"
			+ "&order=highest_score.desc" + "&limit=10"
			,_on_request_completed_when_end)
	

func user_connection_handling() :
		if server_result["data"].is_empty() :
			user = $TextEdit.text
			prepare_insertion() 
			make_request(
					"/player", _on_request_completed_when_user_creation,
					{"name": user, "highest_score" : 0},HTTPClient.METHOD_POST)
			delete_header_after_inerton()
		else :
			highest_score = server_result["data"][0]["highest_score"]
			$highest_score.text = "highest score : "+str(highest_score)

func _on_request_completed_when_end(result, _response_code, _headers, body):
	fist_request_handling(result, _response_code, _headers, body)
	answer_handling(result_showing)

func _on_request_completed_when_entry_gestion(result, _response_code, _headers, body):
	fist_request_handling(result, _response_code, _headers, body)
	answer_handling(user_connection_handling)
	
func _on_request_completed_when_new_highest_score(result, _response_code, _headers, body):
	fist_request_handling(result, _response_code, _headers, body)
	answer_handling(func () : pass)

func _on_request_completed_when_user_creation(result, _response_code, _headers, body):
	fist_request_handling(result, _response_code, _headers, body)
	answer_handling(func () : if server_result["error"] != ""  : error_showing())
	

func _ready():
	pass

func get_config(nom : String) :
	if config.has(nom) : return config[nom]	
	else : return ""

func make_request(parameter : String,signal_handling : Callable,  data = {}, methode : int = HTTPClient.METHOD_GET) :
	var result : int
	var request = HTTPRequest.new()
	add_child(request)
	request.request_completed.connect(signal_handling)
	if data.is_empty() :
		result = request.request(URL + parameter,header, HTTPClient.METHOD_GET)
	else : result = request.request(URL + parameter,header, methode, JSON.stringify(data))
	assert(result == OK)
	

func fist_request_handling(result, response_code, headers, body) :
	if result != HTTPRequest.RESULT_SUCCESS or response_code > 205 :  
		server_result["error"] = "erreur réseau" 
	 	
	else :
		if body.is_empty() : 
			return
		else :
			var json = JSON.parse_string(body.get_string_from_utf8())
			if json == null : 
				server_result["error"] = "erreur réseau"
			elif typeof(json) == TYPE_ARRAY : 
				server_result["data"] = json
			else : server_result["error"] = "erreur réseau"
		
func custom_label(text : String, color : Color = Color(0.451, 0.475, 0.49, 1.0)) :
	var label = Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size",20)
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = color
	label.add_theme_stylebox_override("normal",stylebox)
	label.add_theme_font_override("font",load("res://fonts/Xolonium-Regular.ttf"))
	return label

func answer_handling(function : Callable, ...args) :
	if server_result["error"] != "" : error_showing()
	else : 
		if args.is_empty() : function.call()
		else : function.call(args)

func prepare_insertion() :
	header.append("Prefer: return=minimal")

func delete_header_after_inerton() :
	header.remove_at(header.size()-1)

func result_showing() :
	var header_name_label = custom_label("name")
	var header_score_label = custom_label("score")
	$GridContainer.add_child(header_name_label)
	$GridContainer.add_child(header_score_label)
	for valeur in server_result["data"] :
		var name_label = custom_label(valeur["name"])
		var score_label = custom_label(str(valeur["highest_score"]))
		$GridContainer.add_child(name_label)
		$GridContainer.add_child(score_label)
	$GridContainer.show()

func error_showing() : 
	error.emit()


func charger_env(chemin: String = "res://.env") -> Dictionary:
	var env_vars = {}
	if not FileAccess.file_exists(chemin):
		push_warning("Fichier .env introuvable au chemin : " + chemin)
		return env_vars	
	var file = FileAccess.open(chemin, FileAccess.READ)
	while not file.eof_reached():
		var ligne = file.get_line().strip_edges()
		# Ignorer les lignes vides ou les commentaires
		if ligne == "" or ligne.begins_with("#"):
			continue

		# Séparer la clé et la valeur au premier "="
		var parts = ligne.split("=", true, 1)
		if parts.size() == 2:
			var cle = parts[0].strip_edges()
			var valeur = parts[1].strip_edges()

			env_vars[cle] = valeur

	return env_vars
