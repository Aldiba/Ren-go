shader_type canvas_item;

uniform vec2 iMouse;
uniform vec3 color1;//0.8 0.4 0.2
uniform vec3 color2;//0.12 0.7 0.6
uniform vec3 color3;//0.9 0.4 0.2

void fragment()
{
	vec2 p = FRAGCOORD.xy * SCREEN_PIXEL_SIZE + iMouse.xy* SCREEN_PIXEL_SIZE;

    vec2 cc = 1.1*vec2( 0.5*cos(0.1*TIME) - 0.25*cos(0.2*TIME),
	                    0.5*sin(0.1*TIME) - 0.25*sin(0.2*TIME) );

	vec4 dmin = vec4(1000.0);
    vec2 z = (-1.0 + 1.0*p)*vec2(0.6,0.3);
    for( int i=0; i<64; i++ )
    {
        z = cc + vec2( z.x*z.x - z.y*z.y, 2.0*z.x*z.y );
		z += 0.15*sin(float(i));
		dmin=min(dmin, vec4(abs(0.0+z.y + 0.2*sin(z.x)),
							abs(1.0+z.x + 0.5*sin(z.y)),
							dot(z,z),
						    length( fract(z)-0.2) ) );
    }

    vec3 color = vec3( dmin.w );
	color = mix( color, color1,     min(1.0,pow(dmin.x*0.25,0.20)) );
    color = mix( color, color2,     min(1.0,pow(dmin.y*0.50,0.50)) );
	color = mix( color, color3, 1.0-min(1.0,pow(dmin.z*1.00,0.15) ));

	color = 1.25*color*color;

	color *= 0.5 + 0.5*pow(4.0*p.x*(1.0-p.y)*p.y*(1.0-p.y),0.15);

	COLOR = vec4(color,1.0);
}
