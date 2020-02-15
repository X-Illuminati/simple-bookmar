/* simple bookmark - CC0 license */

/* parameters */
//body
bookmark_width=5;
bookmark_len=125;
bookmark_thickness=0.3;

//topper
topper_image="topper.png";
topper_scale=[0.03,0.03,0.02];
topper_center=10;

/* code */
translate([0,-topper_center+bookmark_len,0])
union() {
	//overall bookmark body shape
	translate([topper_center-bookmark_width/2,topper_center-bookmark_len,0])
		cube([bookmark_width,bookmark_len,bookmark_thickness]);

	//topper
	scale(topper_scale)
		difference() {
			//topper
			translate([0,0,-2])
				surface(file=topper_image, convexity=5);

			translate([0,0,-10]) cube([1000,1000,10]);
		}
}
