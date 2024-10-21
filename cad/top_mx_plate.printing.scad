use <functions.scad>

// Change to large number when pruducing end result
// 256 seems fine for production...
$fn = 64;


// Screws and Encoders are different on each side
is_right = false;
is_plate = false;

// See functions.scad for more info
switch_hole = 14;
plate_thickness = 5.4; // set to 5
switch_snapping = 1.5;
plate_case_tolerance = 0.1;
plate_inset = 1;
// PCB is 4.3
screw_hole_diameter = 1.85; 
screw_depth = plate_thickness - switch_snapping-0.2;
chamfer_depth = 0.2;
rim_height = 5;
case_width = 5;
case_pcb_tolerance = 1; // 0.5
pcb_thickness = 1.6;
bottom_thickness = 5;
// Below the pcb, pcb+components on back (1.6+2ish)=4ish + 5 for bottom plate = 9
case_depth = 4+bottom_thickness;
usb_thickness = 8;
corner_radius = 3;

//module test() {
//  difference() {
//    cube([25,10,screw_depth+3]);
//    for (i=[0:1:5]) {
//      translate([i*4+2.1,7,3]) screw_hole(diameter=1.7+(i*0.05));
//      translate([i*4+2.1,3,3]) screw_hole(diameter=1.7+(i*0.05), fdiameter=2+(i*0.05), fdepth=0.2);
//    }
//  }
//}
//
//!#test();
//

module screw_hole(diameter=screw_hole_diameter, depth=screw_depth, fdiameter=-1, fdepth=0.2) {
  fd = fdiameter == -1 ? diameter+0.3 : fdiameter;
  cylinder(h=depth+0.001,d=diameter);
  translate([0,0,depth-fdepth]) cylinder(h=fdepth+0.001,d1=diameter,d2=fd);
}

// Top level modules
module real_plate() {
  difference() {
    linear_extrude(plate_thickness) offset(delta=plate_inset) plate_outline();
    translate([0,0,-0.001]) linear_extrude(plate_thickness+0.002) key_holes();
    translate([0,0,switch_snapping]) linear_extrude(plate_thickness) key_holes(15);
    translate([0,0,plate_thickness-screw_depth]) plate_screw_placement() {
      screw_hole();
    };
    smd_holes();
    encoder_hole();
    usb_holes();
  }
}

real_plate();

module rims() {
  difference() {
    union() {
      translate([0,0,-rim_height]) linear_extrude(rim_height+0.001) rim_placement(); // Might need a height tolerance?
      translate([0,0,-0.001]) linear_extrude(plate_thickness) difference() {rim_placement(); offset(delta=plate_inset+plate_case_tolerance) plate_outline();}
      translate([0,0,plate_thickness-0.001]) linear_extrude(case_depth) difference() {
        fill() rim_placement();
        offset(delta=-case_width) fill() rim_placement();
      }
    }
    encoder_hole();
    smd_holes();
    // usb-c port
    translate([-34.29,22.225,plate_thickness-4.5]) linear_extrude(4.5) square([10.64,12], center=true);
    translate([-34.29,28+10,plate_thickness-2]) cube([12,20,usb_thickness], center=true);
    // trrs port
    translate([-46.863,19.652,plate_thickness-6]) linear_extrude(6) square([7,15], center=true);
    translate([-46.863,26,plate_thickness-2.5]) rotate(-90, [1,0,0]) linear_extrude(20) circle(d=8);
  }
}

rims();

// Top level 2d modules
module plate_outline() {
  offset(delta=1.3) key_holes(19.05);
}

module smd_holes() {
  // smd components
  translate([-28.165-22,-18.965,plate_thickness-3-0.001]) linear_extrude(3+0.001) square([22,45], center=false);
}

module usb_holes() {
  // usb-c port
  translate([-34.29,22.225,plate_thickness-4.5]) linear_extrude(4.5) square([10.64,12], center=true);
  translate([-34.29,28+10,plate_thickness-2]) cube([12,20,usb_thickness], center=true);
}

module all_holes() {
    translate([0,0,switch_snapping]) linear_extrude(plate_thickness-switch_snapping) key_placement() square(15, center=true);
    usb_holes();
    screw_holes();
    encoder_hole();
    smd_holes();
    // trrs port
    translate([-46.863,19.652,plate_thickness-6]) linear_extrude(6) square([7,15], center=true);
    translate([-46.863,26,plate_thickness-2.5]) rotate(-90, [1,0,0]) linear_extrude(20) circle(d=8);
}

module rim_outline() {
  offset(r=case_width+case_pcb_tolerance) pcb_outline();
}

module rim_placement() {
    difference(){
        rim_outline();
        // My keycaps are 18.3mm^2
        offset(delta=1.3) key_holes(19.05);
    }
}

module key_holes(size=switch_hole) {
    key_placement() square(size, center=true);
}

module plate_screw_placement() {
    if (is_right) {
        translate([-9.135,9.065]) children();
        translate([-21.035,-42.035]) children();
        translate([66.465,-0.735]) children();
        translate([67.265,-22.135]) children();
    } else {
        translate([-9.3,9.1]) children();
        translate([-21.2,-42]) children();
        translate([67.1,-22.1]) children();
        translate([66.3,-0.7]) children();
    }
}

module encoder_placement() {
    translate(is_right?[-39,-26.5]:[-39.5,-25.5]) children();
}

module encoder_hole() {
    encoder_placement() {
        translate([0,0,plate_thickness-3]) linear_extrude(3+0.001) square([18.5,15.2], center=true);
        translate([0,0,plate_thickness-7]) linear_extrude(4+0.001) square([13,12.6],center=true);
        translate([0,0,-rim_height]) linear_extrude(rim_height+plate_thickness-7+0.001) circle(d=7.5); // Circular shaft
    }
}

module pcb_outline() {
    union() {
        outline();
        if (is_right)
            polygon([[-36.394,-58.461], [-50.165,-31.115],[-50.165,26.035],[-28.575,26.035],[0.025,-50.140]]);
        else
            polygon([[-36.322,-58.42],[-50.165,-31.115],[-50,26],[-28.5,26],[0,-50]]);
    }
}

