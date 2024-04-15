shader_type canvas_item;


uniform vec3 _color : source_color;
uniform float _amount : hint_range(0.0, 1.0, 0.01);


void fragment()
{
	COLOR.rgb = mix(COLOR.rgb, _color, _amount);
}
