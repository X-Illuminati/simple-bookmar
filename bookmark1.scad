/* simple bookmark - CC0 license */

/* parameters */
//body
bookmark_width=50;
bookmark_len=125;
bookmark_thickness=0.3;

//pattern
pattern_image="pattern.svg"; //use DXF for earlier versions of OpenSCAD than 2019.05
patern_translation=[12,7,-5];

//features
draft_angle=3;
tab_thickness=3;

/* code */
difference() {
	//overall bookmark body shape
	cube([bookmark_width,bookmark_len,bookmark_thickness]);

	//pattern to carve into the bookmark body
	translate(patern_translation)
		linear_extrude(10, convexity=20)
			import(pattern_image);

	//cut a draft angle on the sides of the bookmark
	translate([bookmark_width,0,-5]) rotate([0,0,draft_angle])
		cube([bookmark_width*2,bookmark_len*2,10]);
	translate([0,0,5]) rotate([0,180,-draft_angle])
		cube([bookmark_width*2,bookmark_len*2,10]);

	//cut a tab into the bookmark
	translate([tab_thickness*2,tab_thickness,5]) rotate([0,180,-draft_angle])
		cube([tab_thickness,bookmark_len-tab_thickness*2,10]);
	translate([bookmark_width-tab_thickness*2,tab_thickness,-5]) rotate([0,0,draft_angle])
		cube([tab_thickness,bookmark_len-tab_thickness*2,10]);
	translate([tab_thickness+tan(draft_angle)*bookmark_len,bookmark_len-tab_thickness*2,-5])
		cube([bookmark_width-tan(draft_angle)*bookmark_len*2-tab_thickness*2,tab_thickness,10]);
}

