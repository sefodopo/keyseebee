use <functions.scad>

// Change to large number when pruducing end result
// 256 seems fine for production...
$fn = $preview ? 16 : 256;


// Screws and Encoders are different on each side
is_right = false;
// Select the part to show, b bottom, t top, p plate
part = "a";

// See functions.scad for more info
switch_hole = 14;
plate_thickness = 5;
switch_snapping = 1.5;
plate_case_tolerance = 0.03;
plate_inset = 1;
keycap_length = 18.3;
keycap_tolerance = 0.5;
// PCB is 4.3
screw_hole_diameter = 3; 
screw_depth = plate_thickness - switch_snapping-0.2;
chamfer_depth = 0.2;
rim_height = 6;
// Make sure to check dovetails when adjusting
case_width = 3;
case_pcb_tolerance = 0.3;
pcb_thickness = 1.6;
bottom_thickness = 2;
// Below the pcb, pcb+components on back (1.6+2ish)=4ish
case_separation = 4;
case_depth = case_separation+bottom_thickness;
// Depth of screw head for countersink I measured 1.2. Higher number to require shorter screws
screw_head = 3;
// 2.1 shrunk down to 2 and 2.3 was still just barely tight
screw_outer_diameter = 2.4;
// 4 shrunk too much for my wider head screws
screw_head_diameter = 4.5;
usb_thickness = 8;
corner_radius = 3;
bottom_case_tolerance = plate_case_tolerance;

tenting_angle = 25;

module everything() {
  if (part == "b") {
    bottom();
    tent();
  } else if (part == "t")
    rims();
  else if (part == "p")
    real_plate();
  else {
    tent();
    bottom();
    rims();
    real_plate();
  }
}

module tent() {
  angle = tenting_angle;
  outer_width = 136.165+2*(case_width+case_pcb_tolerance);
  right_offset = 85.835+case_width+case_pcb_tolerance;
  left_offset = 50.44+case_width+case_pcb_tolerance;
  start = plate_thickness+case_depth;
  cylen = outer_width * tan(angle)+0.02;
  cydia = 5;
  if (angle >= 5) translate([0,0,start-0.1-0.001]) difference() {
    linear_extrude(outer_width*tan(angle)+1) rim_outline();
    translate([-0.001,-0.001,-0.001+right_offset*tan(angle)+1]) rotate([0,angle,0]) linear_extrude(outer_width*tan(angle)+1+0.002) offset(delta=outer_width/cos(angle)-outer_width) rim_outline();
    if (outer_width*tan(angle)+1 > 10) {
      hyp = tan(angle)*outer_width-10;
      #translate([-left_offset-0.001,-75,10]) rotate([0,angle-90,0]) cube([hyp*cos(angle)+1.002,150,sin(angle)*hyp+1.001]);
    }
    translate([0,0,-0.001]) plate_screw_placement() {
      cylinder(h=1,d1=screw_head_diameter, d2=cydia);
      translate([0,0,1-0.001]) cylinder(h=cylen-1,d=cydia);
    }
  }
}

scale([is_right?-1:1,1,1]) everything();


// Top level modules
module real_plate() {
  difference() {
    linear_extrude(plate_thickness-0.48) difference() {
      offset(delta=plate_inset) plate_outline_interconnect();
      weird_rim_cutout();
    }
    translate([0,0,-0.001]) linear_extrude(plate_thickness+0.002) key_holes();
    translate([0,0,switch_snapping]) linear_extrude(plate_thickness+0.001) key_holes(15);
    translate([0,0,plate_thickness-screw_depth]) plate_screw_placement() {
      cylinder(h=screw_depth+0.001, d=screw_hole_diameter);
    };
    smd_holes();
    encoder_hole();
    usb_holes();
  }
}

module rims() {
  module case_rims() {
    difference() {
        fill() rim_placement();
        offset(delta=-case_width) fill() rim_placement();
      }
  }
  // We go from top to bottom which is actually bottom to top since the model is flipped :)
  difference() {
    union() {
      // top rounded part of case
      translate([0,0,-rim_height]) difference() {
        rd = 0.2;
        radius = case_width+case_pcb_tolerance-rd;
        minkowski() {
          linear_extrude(height=rim_height-radius+0.001) offset(delta=rd) pcb_outline();
          translate([0,0,radius]){
            difference() { // semisphere
              sphere(r=radius);
              translate([0,0,radius+0.001]) cube(radius*2+0.002, center=true);
            }
          }
        }
        translate([0,0,-0.001]) linear_extrude(height=rim_height+0.003)plate_outline();
      }

      // plate slice
      translate([0,0,-0.001]) linear_extrude(plate_thickness-0.4+0.002) {
        difference() {
          rim_placement(); 
          offset(delta=plate_inset+plate_case_tolerance) plate_outline_interconnect();
        }
        offset(delta=-2*plate_case_tolerance) weird_rim_cutout();
      }
      translate([0,0,plate_thickness-0.4-0.001]) linear_extrude(0.4+0.002) difference() {
        fill() rim_placement();
        plate_outline();
      }

      // pcb slice
      translate([0,0,plate_thickness-0.001]) linear_extrude(case_depth-bottom_thickness+0.002) difference() {
        rim_outline();
        offset(delta=-case_width) rim_outline();
      }

      // bottom cover slice
      translate([0,0,plate_thickness+case_depth-bottom_thickness-0.001]) linear_extrude(height=bottom_thickness+0.002) difference() {
        rim_outline();
        offset(r=-case_width/2) rim_outline();
      }
    }
    encoder_hole();
    smd_holes();
    translate([0,0,switch_snapping]) linear_extrude(plate_thickness+0.001) key_holes(15);
    translate([0,0,plate_thickness-screw_depth]) plate_screw_placement() {
      cylinder(h=screw_depth+0.002, d=screw_hole_diameter);
    };
    usb_holes();
    // trrs port
    translate([-46.863,19.652,plate_thickness-6]) linear_extrude(6) square([7,15], center=true);
    translate([-46.863,26,plate_thickness-2.5]) rotate(-90, [1,0,0]) linear_extrude(20) circle(d=8);
  }
}


module bottom() {
  start = plate_thickness+case_depth-bottom_thickness;
  end = plate_thickness+case_depth;
  difference() {
    union() {
      translate([0,0,start]) linear_extrude(bottom_thickness) 
        offset(r=-case_width/2) offset(delta=-bottom_case_tolerance) rim_outline();
      plate_screw_placement() {
        translate([0,0,plate_thickness+bottom_case_tolerance]) cylinder(h=2+0.001,d=4);
        translate([0,0,plate_thickness+bottom_case_tolerance+1.8-0.001]) cylinder(h=start-plate_thickness-bottom_case_tolerance+0.001, d1=4, d2=10);
      }
    }

    plate_screw_placement() {
      translate([0,0,start-case_separation-0.001]) cylinder(h=bottom_thickness+case_separation+0.002,d=screw_outer_diameter);
      translate([0,0,end-screw_head]) cylinder(h=1.5+0.001, d1=screw_outer_diameter, d2=screw_head_diameter);
      translate([0,0,end-screw_head+1.5-0.001]) cylinder(h=screw_head-1.5+0.002,d=screw_head_diameter);
    }
  }
}


// Top level 2d modules

// The outline of the plate where the rims should start
module plate_outline() {
  // My keycaps are 18.3mm^2
  offset(delta=keycap_tolerance) key_holes(keycap_length);
}

module weird_rim_cutout() {
  offset(delta=plate_case_tolerance) intersection() {
    rim_placement();
    translate([-10,-37.965]) square([40,20]);
  }
}

module plate_outline_interconnect() {
  plate_outline();

  // Add padding for the screw
  translate([-27,-49]) square([10,10]);

  // Dovetails
  d = keycap_length/2+keycap_tolerance+plate_inset;
  translate([76.2+d-0.001,-12.7]) rotate(-90) dovetail(w=20,h=0.3);
  translate([-19.05-d+0.001,0]) rotate(90) dovetail(w=17,h=1);
  translate([57.15-6,-29.21-d+0.001]) rotate(180) dovetail(w=8,h=2);
  translate([57.15+2,8.89+d-0.001]) dovetail(w=4,h=2);
  translate([-32.131,-45.72]) rotate(26.5) translate([0,-d+0.001]) rotate(180) dovetail(w=7,h=0.5);
  translate([19.05,21.59+d-0.001]) dovetail(h=0.01);
  translate([-2,19.05+d-0.001]) dovetail(w=7, h=0.3);
  translate([15,-38.1-d+0.001]) rotate(180) dovetail(w=10,h=0.5);
}

module dovetail(w=10,h=2) {
  polygon([[-w/2,0], [-w/2-h,h], [w/2+h,h], [w/2,0]]);
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

module rim_outline() {
  offset(r=case_width+case_pcb_tolerance) pcb_outline();
}

module rim_placement() {
    difference(){
        rim_outline();
        plate_outline();
    }
}

module encoder_placement() {
    translate(is_right?[-39,-26.5]:[-39.5,-25.5]) children();
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

module key_holes(size=switch_hole) {
    key_placement() square(size, center=true);
}


// 3d holes

module smd_holes() {
  // smd components
  translate([-28.165-22,-18.965,plate_thickness-3-0.001]) linear_extrude(3+0.003) square([22,45], center=false);
}

module usb_holes() {
  // usb-c port
  translate([-34.29,22.225,plate_thickness-4.5]) linear_extrude(5) square([10.64,12], center=true);
  translate([-34.29,28+10,plate_thickness-2]) cube([12,20,usb_thickness], center=true);
}

module encoder_hole() {
    encoder_placement() {
        translate([0,0,plate_thickness-3-0.001]) linear_extrude(3+0.003) square([18.5,15.2], center=true);
        translate([0,0,plate_thickness-7-0.001]) linear_extrude(4+0.002) square([13,12.6],center=true);
        translate([0,0,-rim_height-0.001]) linear_extrude(rim_height+plate_thickness-7+0.001) circle(d=7.5); // Circular shaft
    }
}

