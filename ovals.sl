// Michael Rose
// January 13th 2016
// As of January 13th, 2016, this file compiles using 
// shader.exe from the non-commercial version of
// Renderman found in RenderManProServer-20.6
surface
ovals(
	float
		Ad = 0.025,				// width of each stripe
		Bd = 0.10,				// height of each stripe
		Ks = 0.4,				// specular coefficient
		Kd = 0.5, 				// diffuse  coefficient
		Ka = 0.1, 				// ambient  coefficient
		Roughness = 0.1;			// specular roughness
	color	SpecularColor = color( 1, 1, 1 )	// specular color
)
{
	color PINK = color( 1., 0.0784, 0.577 );
	color PURPLE = color( 0.577, 0.44, 0.86 );
	// be sure the normal points correctly (used for lighting):

	varying vector Nf = faceforward( normalize( N ), I );
	vector V = normalize( -I );

	// determine how many squares over and up we are in right now:

	float up = 2. * u;	// because we are rendering a sphere
	float vp = v;
	float numinu = floor( up / (2*Ad) );
	float numinv = floor( vp / (2*Bd) );
	float uc = numinu * 2 * Ad + Ad;
	float vc = numinv * 2 * Bd + Bd;
	
	// use whatever opacity the rib file gave us)

	Oi = Os;

	// handle the oval coloring:

        color TheColor = Cs;
        	//.9 adds space between the ovals
	   if( (((up-uc)/Ad)*((up-uc)/Ad)+((vp-vc)/Bd)*((vp-vc)/Bd)) <=.9 )
		   TheColor = PINK;
	   else
		   Oi = PURPLE;


	// determine the lighted output color Ci:
	//based upon how the color interacts with the ambient, diffuse and specular lighting

	Ci =        TheColor * Ka * ambient();
	Ci = Ci  +  TheColor * Kd * diffuse(Nf);
	Ci = Ci  +  SpecularColor * Ks * specular( Nf, V, Roughness );
	Ci = Ci * Oi;
}
