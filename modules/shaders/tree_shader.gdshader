shader_type canvas_item;


uniform vec4 _hit_color : source_color;
uniform float _hit_amount : hint_range(0.0, 1.0, 0.01);

uniform sampler2D _blood_texture;
uniform float _blood_amount : hint_range(0.0, 1.0, 0.01);

uniform sampler2D _distortion_texture : repeat_enable;
uniform float _distortion_amount : hint_range(0.0, 1.0, 0.01);
uniform float _distortion_y_cap : hint_range(0.0, 1.0, 0.01);

void fragment()
{
	vec2 distorted_uv = UV;
	vec4 distorted_color = COLOR;
	if (UV.y < _distortion_y_cap)
	{
		vec2 time_offset = vec2(TIME * 0.1, 0);
		vec2 offset = texture(_distortion_texture, UV + time_offset).rg - vec2(0.5, 0.5);
		distorted_uv = UV + offset * _distortion_amount;
		distorted_color = texture(TEXTURE, distorted_uv);
	}
	
	vec4 blood_color = texture(_blood_texture, distorted_uv);
	vec3 color = mix(distorted_color.rgb, blood_color.rgb, _blood_amount * blood_color.a);
	COLOR.rgb = mix(color.rgb, _hit_color.rgb, _hit_amount * _hit_color.a);
}
