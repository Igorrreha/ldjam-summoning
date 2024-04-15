shader_type canvas_item;


uniform float _amount : hint_range(0.0, 1.0, 0.01);
uniform sampler2D _texture;


void fragment()
{
	vec4 additional_color = texture(_texture, UV);
	COLOR.rgb = mix(COLOR.rgb, additional_color.rgb, _amount * additional_color.a);
}
