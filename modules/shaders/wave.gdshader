shader_type canvas_item;


uniform sampler2D _distortion_texture : repeat_enable;
uniform float _amount : hint_range(0.0, 1.0, 0.01);
uniform float _y_cap : hint_range(0.0, 1.0, 0.01);


void fragment()
{
	if (UV.y < _y_cap)
	{
		vec2 time_offset = vec2(TIME * 0.1, 0);
		vec2 offset = texture(_distortion_texture, UV + time_offset).rg - vec2(0.5, 0.5);
		vec4 color = texture(TEXTURE, UV + offset * _amount);
		COLOR = color;
	}
}
