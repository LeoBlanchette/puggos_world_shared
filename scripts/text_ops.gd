
class_name TextOps

static func color_text(text:String, color:Color)->String:
	var colored_text:String = "[color=%s]%s[/color]"%[color.to_html(), text]
	return colored_text

static func print_text_array_to_console(text_array:Array):
	for line in text_array:
		print_rich(line)
