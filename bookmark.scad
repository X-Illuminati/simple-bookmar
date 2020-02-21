/* simple bookmark - CC0 license */

/* parameters */
//body
bookmark_width=40;
bookmark_len=130;
bookmark_thickness=0.5;

//pattern
pattern_image="pattern.svg"; //use DXF for earlier versions of OpenSCAD than 2019.05
patern_translation=[30,33,-5];
pattern_scale=[.1,.1];
pattern_rotation=180;

//features
draft_angle=.4;
fillet_radius=5;


/* helper functions */
function draft_skew() = sin(draft_angle)*bookmark_len;

/* helper modules */
module fillet_tool(r=1, angle=0) {
	rotate([0,0,angle]) translate([0,0,-5])
		difference() {
			cube([2*r,2*r,10]);
			translate([0.01,0.01,-1])
				cylinder(h=12, r=r, $fn=30);
		}
}


/* main module */
difference() {
	//overall bookmark body shape
	cube([bookmark_width,bookmark_len,bookmark_thickness]);

	//pattern to carve into the bookmark body
	translate(patern_translation)
		linear_extrude(10, convexity=20)
			scale(pattern_scale) rotate(pattern_rotation)
				import(pattern_image);

	//cut a draft angle on the sides of the bookmark
	translate([bookmark_width,0,-5]) rotate([0,0,draft_angle])
		cube([bookmark_width*2,bookmark_len*2,10]);
	translate([0,0,5]) rotate([0,180,-draft_angle])
		cube([bookmark_width*2,bookmark_len*2,10]);

	//cut fillets in the corners
	translate([bookmark_width-draft_skew()-fillet_radius, bookmark_len-fillet_radius])
		fillet_tool(fillet_radius, 0);
	translate([draft_skew()+fillet_radius, bookmark_len-fillet_radius])
		fillet_tool(fillet_radius, 90);
	translate([fillet_radius, fillet_radius])
		fillet_tool(fillet_radius, 180);
	translate([bookmark_width-fillet_radius, fillet_radius])
		fillet_tool(fillet_radius, 270);
}

