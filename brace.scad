
// diameter of the tube (mm)
tubeDiameter = 2.197*25.4; 

// hole size of the bearing (mm)
bearingHoleDiameter = 8;

// bearing diameter (mm)
bearingDiameter = 22;

// bearing width (mm)
bearingWidth = 7;

// bearing collar thickness (mm)
bearingCollarThickness = 2;

// minimum thickness of the walls (mm)
wallThickness = 15;

// minimum thickness of the walls (mm)
wallHeight = 0;

// the space between the bearing and the wall (mm)
tolerance = 2;

// the space between the tube and the wall (mm)
tubeTolerance = 2;

// determines beefiness of edge extensions
beefiness = 2;//9;

reinforcement = 8;

hexHead = 25.4/2;

module Outer() {
translate([bearingWidth/2,tubeDiameter/2+bearingDiameter/2,0])
    rotate([0,90,0]) union() {
        hull() {
                cylinder(r=bearingHoleDiameter/2+bearingCollarThickness,h=0.01,$fn=90);
                translate([0,0,tolerance])
                    cylinder(r=bearingHoleDiameter/2+bearingCollarThickness+tolerance,h=0.01,$fn=90);
        }
        translate([-bearingDiameter/2-wallHeight,-bearingDiameter/2-wallThickness,tolerance])
            cube([bearingDiameter+2*wallHeight,bearingDiameter+wallThickness+2*tolerance,wallThickness]);
        hull() {
                translate([0,0,2*tolerance+wallThickness])
                    cylinder(r=bearingHoleDiameter/2+bearingCollarThickness,h=0.01,$fn=90);
                translate([0,0,tolerance+wallThickness])
                    cylinder(r=bearingHoleDiameter/2+bearingCollarThickness+tolerance,h=0.01,$fn=90);
        }
    }
}

module cylinder_outer(height,radius,fn){
   fudge = 1/cos(180/fn);
   cylinder(h=height,r=radius*fudge,$fn=fn);
}
fudge = 1/cos(180/6);
module BraceSingle() {
    lip = 0;
translate([bearingWidth/2,tubeDiameter/2+bearingDiameter/2,0])
    rotate([0,90,0]) union() {
        hull() {
                translate([-lip/2-fudge*hexHead/2,-lip/2-fudge*hexHead/2,2*tolerance+wallThickness])
                    cube([fudge*hexHead+lip,fudge*hexHead+lip,reinforcement]);
        }
    }
}

module BraceReliefSingle() {
    lip = 0;
translate([bearingWidth/2,tubeDiameter/2+bearingDiameter/2,0])
    rotate([0,90,0]) union() {
        hull() {
                translate([-lip/2-fudge*hexHead/2,-lip/2-fudge*hexHead/2,2*tolerance+wallThickness+reinforcement])
                    cube([fudge*hexHead+lip,fudge*hexHead+lip,100]);
        }
    }
}

module Inner() {
    translate([bearingWidth/2,tubeDiameter/2+bearingDiameter/2,0])
        rotate([0,90,0]) 
            cylinder(r=bearingHoleDiameter/2,h=100, $fn=90); // arbitrary large value for hole length
}

module Bearing() {
    translate([0,tubeDiameter/2+bearingDiameter/2,0])
        rotate([0,90,0]) color("red", 0.5)
            cylinder(r=bearingDiameter/2,h=bearingWidth, center=true, $fn=90); 
}

module Tube() {
    color("green", 0.5)
        cylinder(r=tubeDiameter/2,h=100, center=true, $fn=90); 
}

module Brace()
{
    elongate = 3;
    difference() {
        hull() {
            BraceSingle();
            rotate([0,0,-120]) mirror([1,0,0]) BraceSingle();
        }
        hull() {
            BraceReliefSingle();
            rotate([0,0,-120]) mirror([1,0,0]) {
                BraceReliefSingle();
            }
        }
        Inner();
        hull() rotate([0,0,-120]) mirror([1,0,0]) {
            Inner();
            translate([0,-elongate,0]) Inner();
        }
    }
}

Brace();