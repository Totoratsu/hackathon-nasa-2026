shader_type canvas_item;
// Vuelve transparente el blanco del exterior del marco (esquinas del jpeg).
// Se excluye la zona del titulo "MISSIONS", que tiene letras casi blancas.
void fragment() {
	vec4 c = texture(TEXTURE, UV);
	float blanco = smoothstep(0.88, 0.96, min(c.r, min(c.g, c.b)));
	bool titulo = UV.x > 0.31 && UV.x < 0.69 && UV.y > 0.10 && UV.y < 0.24;
	if (!titulo) {
		c.a *= 1.0 - blanco;
	}
	COLOR = c;
}
