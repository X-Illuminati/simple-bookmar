/*
 * Simple Bookmark
 * (C) 2020 Chris Baker
 * No rights reserved.
 *
 * To the extent possible under law, Chris Baker has waived all
 * copyright and related or neighboring rights to Simple Bookmark.
 */

/* output options */
outline_mode=false;


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
module simple_bookmark() {
	difference() {
		//overall bookmark body shape
		cube([bookmark_width,bookmark_len,bookmark_thickness]);

		//pattern to carve into the bookmark body
		if (!outline_mode)
			translate(patern_translation) translate([0,0,-5])
				linear_extrude(10, convexity=20)
					scale(pattern_scale) rotate(pattern_rotation)
						import(pattern_image);

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

if (outline_mode)
	projection()
		simple_bookmark();
else
	simple_bookmark();
