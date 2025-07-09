shader_type canvas_item;

uniform float number = 123.789;

float rand(vec2 p, float timeOffset)
{
	p += 0.2127*timeOffset + p.x + 0.3713*p.y;
	vec2 r = (number)*sin(1.823*(p));
	return fract(r.x*r.y);
}

float sn(vec2 p, float timeOffset)
{
	vec2 i=floor(p-0.5);
	vec2 f=fract(p-0.5);
	f = f*f*f*(f*(f*6.0-15.0)+6.0);
	float rt=mix(rand(i, timeOffset),rand(i+vec2(1.,0.), timeOffset),f.x);
	float rb=mix(rand(i+vec2(0.0,1.0), timeOffset),rand(i+vec2(1.0,1.0), timeOffset),f.x);
	return mix(rt,rb,f.y);
}

void fragment()
{

	vec2 p = FRAGCOORD.xy*vec2(0.012);

	//fragColor = vec4(vec3(sn(vec2(0.02)*fragCoord.xy)),1.0);
	COLOR = vec4(vec3(
	0.5*sn(p, 1.0)
	+0.25*sn(2.0*p, 1.0)
	+0.125*sn(4.0*p, 1.0)
	+0.0625*sn(8.0*p, sin(TIME*0.00025))
	+0.03125*sn(16.0*p, sin(TIME*0.00032))
	+0.015*sn(32.0*p, sin(TIME*0.00046))
	),1.);
}