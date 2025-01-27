precision mediump float;

varying vec4 v_Position;

/**
 * Macros that define constants used in the fragment shader program. 
 */
#define MIN_DISTANCE 0.00
#define MAX_DISTANCE 0.02
#define MIDLINE 0.0

#define WAVELENGTH 0.5
uniform vec4 u_Colors[3];

/**
 *  This function generates the appropriate alpha value for the fragment color
 *  to render a laser that looks like a sin wave. The alpha value depends on 
 *  the distance of the vertex position from the sine waves curve. Positions
 *  closer to the curve of the sin wave should have a higher alpha value.
 *
 *  +------------------------------------------------------+
 *  | 	   __	  __	 __		__	   __	  __		   | 
 *  | 	  /	 \	 /	\	/  \   /  \	  /	 \	 /	\		   |
 *  |   _/	  \_/	 \_/	\_/	   \_/	  \_/	 \_		   |  
 *  | 													   |
 *  +------------------------------------------------------+
 *
 *  @param position - the position from the vertex shader (v_Position)
 *  @return - the alpha value of the fragment color
 */
float sinwave_laser(vec4 position);

/**
 *  This function generates the appropriate alpha value for the fragment shader
 *  to render a laser that is a straight line. The alpha value depends on the
 *  distance of the vertex fragments position from the midline of the lasers
 *  bounding rectangle. 
 *
 *  +------------------------------------------------------+
 *  | 													   |
 *  + -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  -  - + <- this is the midline
 *  |													   |
 *  +------------------------------------------------------+
 */
float linear_laser(vec4 position);

// TODO Need to somehow pass in the color from the laser shader type
void main(){
	float sinValue = sin(v_Position.x * 10.0);
  	vec4 color;
  	if (sinValue < 0.10){
    	color = mix(u_Colors[0], u_Colors[1], sinValue);
  	} else {
    	color = mix(u_Colors[1], u_Colors[2], sinValue);
  	}

  	gl_FragColor = color;

	gl_FragColor.a = sinwave_laser(v_Position);
}


// TODO Get the laser to look like a sinwave
float sinwave_laser(vec4 position) {
	float x = position.x;
	float y = position.y;

	float distance_from_wave = abs((y * 2.0) + (MIDLINE + MAX_DISTANCE * sin(x * 10.0 * 3.14159)));
	float alpha = 1.0 - (distance_from_wave / MAX_DISTANCE);
	return clamp(alpha, 0.0, 1.0);
}

float linear_laser(vec4 position) {
	return 1.0;
}


