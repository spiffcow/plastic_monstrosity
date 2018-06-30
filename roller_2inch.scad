
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

reinforcement = 7;

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
translate([bearingWidth/2,tubeDiameter/2+bearingDiameter/2,0])
    rotate([0,90,0]) union() {
        hull() {
                translate([0,0,2*tolerance+wallThickness])
                    cylinder(r=fudge*hexHead/2,h=0.01,$fn=6);
                translate([0,0,2*tolerance+wallThickness+reinforcement])
                    cylinder(r=fudge*hexHead/2,h=0.01,$fn=6);
        }
    }
}

module BraceReliefSingle() {
translate([bearingWidth/2,tubeDiameter/2+bearingDiameter/2,0])
    rotate([0,90,0]) union() {
        hull() {
                translate([0,0,2*tolerance+wallThickness+reinforcement])
                    cylinder(r=fudge*hexHead/2,h=reinforcement,$fn=6);
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

testFit = true;

module Roller()
{
    for (m=[[0,0,0],[1,0,0]]) mirror(m) {
        if (testFit) {
            Bearing();
            rotate([0,0,-120]) Bearing();
            Tube();
        }

        difference() {
            union() {
                color("blue", 0.5) Brace();
                Outer();
                rotate([0,0,-120]) mirror([1,0,0]) Outer();
                translate([sin(60)*(tubeDiameter/2-wallThickness/2),cos(60)*(tubeDiameter/2-wallThickness/2),0]) {
                    hull() {
                        translate([0,tubeDiameter/2+beefiness,0])
                            cylinder(r=0.01,h=bearingDiameter+2*wallHeight, center=true, $fn=90);
                        rotate([0,0,-120]) {
                            translate([0,tubeDiameter/2+beefiness,0]) 
                                cylinder(r=0.01,h=bearingDiameter+2*wallHeight, center=true, $fn=90);
                        }
                        cylinder(r=0.01,h=bearingDiameter+2*wallHeight, center=true, $fn=90);
                    }
                }
                translate([-wallThickness-tolerance-bearingWidth/2,tubeDiameter/2+bearingDiameter+tolerance,-(bearingDiameter+2*wallHeight)/2])
                    cube([2*wallThickness+2*tolerance+bearingWidth,wallThickness,bearingDiameter+2*wallHeight]);
            }
            cylinder(r=tubeDiameter/2+tubeTolerance,h=bearingDiameter+2*wallThickness, center=true, $fn=90);
            Inner();
            rotate([0,0,-120]) mirror([1,0,0]) Inner();
        }
    }
}

//Roller();

module Brace()
{
    color("blue", 0.5) difference() {
        hull() {
            BraceSingle();
            rotate([0,0,-120]) mirror([1,0,0]) BraceSingle();
        }
        BraceReliefSingle();
        rotate([0,0,-120]) mirror([1,0,0]) BraceReliefSingle();
    }
}

Brace();