shader_type canvas_item;


uniform vec4 _hit_color : source_color;
uniform float _hit_amount : hint_range(0.0, 1.0, 0.01);

uniform sampler2D _blood_texture;
uniform float _blood_amount : hint_range(0.0, 1.0, 0.01);


void fragment()
{
	vec4 blood_color = texture(_blood_texture, UV);
	vec3 color = mix(COLOR.rgb, blood_color.rgb, _blood_amount * blood_color.a);
	COLOR.rgb = mix(color.rgb, _hit_color.rgb, _hit_amount * _hit_color.a);
}
