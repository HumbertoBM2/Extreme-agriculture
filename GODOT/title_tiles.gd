extends TileMap

const boundary_atlas_pos = Vector2i(0, 3)
const rocket_atlas_pos = Vector2i(5, 0)
const main_source = 4

var tween : Tween

func _ready() -> void:
	place_boundaries()

func place_boundaries():
	var offsets = [
		Vector2i(0, -1),
		Vector2i(0, 1),
		Vector2i(1, 0),
		Vector2i(-1, 0),
	]
	
	var used = get_used_cells(0)
	
	for spot in used:
		for offset in offsets:
			var current_spot = spot + offset
			if get_cell_source_id(0, current_spot) == -1:
				set_cell(0, current_spot, main_source, boundary_atlas_pos)
				set_cell(1, spot, main_source, rocket_atlas_pos)

func _process(delta):
	pass


func _on_start_button_pressed():
	JavaScriptBridge.eval("""

	async function main() {
		port = await navigator.serial.requestPort({ filters: [] });
		
		await port.open({ baudRate: 9600 });
		
		const textDecoder = new TextDecoderStream();
		const readableStreamClosed = port.readable.pipeTo(textDecoder.writable);
		const reader = textDecoder.readable.getReader();

		while (port.readable) {
		  const { value, done } = await reader.read();
		  if (done) {
			reader.releaseLock();
			break;
		  }
		  // value is a string.
		  console.log(value);
		}
	}
	
	main();
	""", true)
	
	#JavaScriptBridge.eval("alert( \"{hi}\" );".format({"hi": "HELLO"}) )
	
	
	#JavaScriptBridge.eval("alert('Calling JavaScript per GDScript!');")
	
	tween = create_tween()
	tween.tween_property(self, "position:y", -800, 4.0)
