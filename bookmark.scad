/*
 * Simple Bookmark
 * (C) 2020 Chris Baker
 * No rights reserved.
 *
 * To the extent possible under law, Chris Baker has waived all
 * copyright and related or neighboring rights to Simple Bookmark.
 */


/* output options */
outline_mode=0; //0=normal, 1=outline, 2=expansion


/* parameters */
//body
bookmark_width=45;
bookmark_len=150;
bookmark_thickness=0.4;

//pattern
pattern_image="pattern.svg";
patern_translation=[58.35,195];
pattern_scale=[1,1];
pattern_rotation=180;

//features
draft_angle=.4;
fillet_radius=5;
hole_radius=6/2;
hole_offset=8;
edge_guard=5;


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

module bookmark_outline(height=bookmark_thickness, expansion=0) {
	//apply expansion factor
	bookmark_width=bookmark_width+expansion;
	bookmark_len=bookmark_len+expansion;
	fillet_radius=(fillet_radius+expansion/2 > 0) ?
		fillet_radius+expansion/2 : .1;
	hole_radius=hole_radius-expansion/2;
	hole_offset=hole_offset+expansion;

	//create the outline
	translate([-expansion/2,-expansion/2])
		difference() {
			//overall bookmark body shape
			cube([bookmark_width,bookmark_len,height]);

			//put a hole in the top e.g. for a tassel
			translate([bookmark_width/2,hole_offset+hole_radius,-5])
				cylinder(h=10, r=hole_radius, $fn=30);

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
}


/* main module */
module simple_bookmark() {
	//create the bookmark shape with carved pattern
	difference() {
		bookmark_outline();

		//pattern to carve into the bookmark body
		translate(patern_translation) translate([0,0,-5])
			linear_extrude(10, convexity=20)
				scale(pattern_scale) rotate(pattern_rotation)
					import(pattern_image);
	}

	//create an edge guard
	difference() {
		bookmark_outline();

		//carve out center leaving just expanded portion
		translate([0,0,-1])
			bookmark_outline(height=2, expansion=-edge_guard);
	}
}

if (outline_mode == 0)
	simple_bookmark();

if (outline_mode == 1)
	projection()
		bookmark_outline();

if (outline_mode == 2)
	projection()
		bookmark_outline(expansion=-edge_guard);
