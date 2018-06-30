include<constants.scad>;
use<vslot.scad>;

// diameter of the tube (mm)
tubeDiameter = 60.3;//(2.197*25.4);//*0.925; 

beltWidth = 10;

beltHeight = 6;

screwDiameter = 5;

screwHeadDiameter = 10;

nutTrapWidth = 8;

nutTrapHeight = 3;

separation = 1;

beltPitch = 2;

beltToothHeight = 1.5;

wallWidth = 3;

height = 20;
mirror([0,0,1]) 
difference() {
    hull() {
        translate([0,tubeDiameter/2,0]) 
            cylinder(h=height, r=tubeDiameter/2+wallWidth, $fn=90);
        for (i=[[0,0,0],[1,0,0]]) mirror(i) {
            translate([tubeDiameter/2,0,0])
                cube([2*wallWidth+nutTrapWidth, 2*wallWidth+separation + nutTrapHeight, height]);
        }
    }
    
    translate([0,tubeDiameter/2,0])
        cylinder(h=height, r=tubeDiameter/2, $fn=90);
    
    for (i=[[0,0,0],[1,0,0]]) mirror(i) {
        translate([0,separation/2,0]) rotate([0,0,180])
            cube([tubeDiameter/2+2*wallWidth+nutTrapWidth, tubeDiameter, height]);
        
        translate([tubeDiameter/2 + wallWidth + nutTrapWidth/2, -tubeDiameter/2-wallWidth, height/2]) 
        rotate([-90,0,0]) {
            cylinder(r=screwDiameter/2, h=tubeDiameter+2*wallWidth, $fn=90);
        }
        
        translate([tubeDiameter/2 + wallWidth + nutTrapWidth/2, wallWidth, height/2]) 
        rotate([-90,0,0]) {
            cylinder(r=screwHeadDiameter/2, h=tubeDiameter+wallWidth, $fn=90);
        }
    }
    
    translate([0,0,height/2]) rotate([-90,0,0])
        cylinder(h=tubeDiameter+wallWidth+separation+wallWidth,r=screwDiameter/2, $fn=90);
}