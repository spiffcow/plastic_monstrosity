include<constants.scad>;
use<vslot.scad>;

// diameter of the tube (mm)
tubeDiameter = (2.197*25.4);//*0.925; 

// bearing diameter (mm)
bearingDiameter = 22;

bearingTolerance = 2;

beltWidth = 10;

beltHeight = 6;

screwDiameter = 5;

screwHeadDiameter = 10;

nutTrapWidth = 8;

nutTrapHeight = 3;

separation = 2;

beltPitch = 2;

beltToothHeight = 1.5;

wallWidth = 5;

height = 20;
mirror([0,0,1]) 
difference() {
    hull() {
        cylinder(h=height, r=tubeDiameter/2+wallWidth, $fn=90);
        for (i=[[0,0,0],[1,0,0]]) mirror(i) {
            translate([tubeDiameter/2,-1*wallWidth-separation/2-nutTrapHeight,0])
                cube([2*wallWidth+nutTrapWidth, 2*wallWidth+separation + nutTrapHeight, height]);
        }
            
        translate([-beltWidth/2-1*wallWidth-nutTrapWidth,tubeDiameter/2+bearingDiameter+bearingTolerance,0])
            cube([beltWidth+2*wallWidth+2*nutTrapWidth,wallWidth+beltToothHeight + separation, height]);
    }
    
    cylinder(h=height, r=tubeDiameter/2, $fn=90);
    
    for (i=[[0,0,0],[1,0,0]]) mirror(i) {
        translate([tubeDiameter/2,-separation/2,0])
            cube([2*wallWidth+nutTrapWidth, separation, height]);
        
        translate([tubeDiameter/2 + wallWidth, -separation/2-wallWidth/2-nutTrapHeight,0])
            cube([nutTrapWidth,nutTrapHeight,height]);
        
        translate([tubeDiameter/2 + wallWidth + nutTrapWidth/2, -tubeDiameter/2-wallWidth, height/2]) 
        rotate([-90,0,0]) {
            cylinder(r=screwDiameter/2, h=tubeDiameter+2*wallWidth, $fn=90);
        }
        
        translate([tubeDiameter/2 + wallWidth + nutTrapWidth/2, wallWidth, height/2]) 
        rotate([-90,0,0]) {
            cylinder(r=screwHeadDiameter/2, h=tubeDiameter/2+wallWidth, $fn=90);
        }
        
        translate([beltWidth/2+wallWidth/2, tubeDiameter/2+bearingDiameter+bearingTolerance-wallWidth/2-nutTrapHeight,0])
            cube([nutTrapWidth,nutTrapHeight,height]);
        
        translate([beltWidth/2+wallWidth/2+nutTrapWidth/2, tubeDiameter/2+bearingDiameter+bearingTolerance-wallWidth/2-nutTrapHeight,height/2])
        rotate([-90,0,0]) {
            cylinder(r=screwDiameter/2, h=tubeDiameter+2*wallWidth, $fn=90);
        }
    }
    
    
    translate([-beltWidth/2,tubeDiameter/2+bearingDiameter+bearingTolerance,0]) {
        for(i=[0:beltPitch:height]) {
            hull() {
                translate([0,beltToothHeight-0.01,i])
                    cube([beltWidth,0.01,0.01]);
                translate([0,0,i+beltPitch])
                    cube([beltWidth,beltToothHeight,0.01]);
            }
        }
    }
    
    translate([-tubeDiameter/2-wallWidth,tubeDiameter/2+bearingDiameter+bearingTolerance+beltToothHeight,0]) {
        cube([tubeDiameter+2*wallWidth,separation,height]);
    }
}