shader_type spatial;
render_mode blend_mul,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,shadows_disabled,alpha_to_coverage;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 val = texture(texture_albedo, UV + vec2(sin(TIME), TIME) * 0.01);
	vec4 val2 = texture(texture_albedo, UV + vec2(1.0, 2.0) + vec2(TIME, sin(TIME + 0.33)) * 0.01);
	vec4 val3 = texture(texture_albedo, UV + vec2(3.0, 4.0) + vec2(sin(TIME * 0.69), sin(TIME * .420)) * 0.01);
	vec4 val4 = texture(texture_albedo, UV + vec2(5.0, 6.0) + vec2(sin(TIME * 0.420), sin(TIME * 1.420)) * 0.01);
	vec4 val5 = texture(texture_albedo, UV + vec2(7.0, 3.0) + vec2(sin(TIME * 0.1), sin(TIME * .920)) * 0.01);

	
	ALPHA = val.a + val2.a + val3.a + val4.a + val5.a;
	ALBEDO = vec3(
		sin(TIME + UV.x * 10.0 + 1.0) / 2.0 + 0.5, 
		sin(TIME + UV.y * 4.0 + 2.0) / 2.0 + 0.5, 
		sin(TIME + UV.x * 1.0 + 3.0) / 2.0 + 0.5
	);
	
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
