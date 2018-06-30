include<constants.scad>;
use<vslot.scad>;

// external values
vWheelHoleSeparation = 5.95;
wallThickness = 8;
plateHoleSideOffset = 11;
nema23ScrewHoleSeparation = 47.14;
nema23ScrewDiameter = 5;
nema23Offset = 10;
smallBearingDiameter=16;
cBeamWidth=80;

newH = vWheelHoleSeparation+plateHoleSideOffset+nema23Offset-smallBearingDiameter/2-wallThickness;

// inherited values

beltWidth = 10;

beltHeight = 6;

screwDiameter = 5.5;

screwHeadDiameter = 10;

nutTrapWidth = 8;

nutTrapHeight = 3;

separation = 2;

beltPitch = 2;

beltToothHeight = 1.5;

wallWidth = 5;

holeSpacing = 20;

longScrewHeight = 40 - wallThickness-4;

extraOffset = 0;

height = 20;
mirror([0,0,1]) 
difference() {
    translate([-holeSpacing/2-screwDiameter/2-wallWidth,-separation/2-newH,0])
        cube([holeSpacing+screwDiameter+2*wallWidth,longScrewHeight, height]);
    
    translate([-holeSpacing/2-screwDiameter/2-wallWidth,-separation,0])
        cube([holeSpacing+screwDiameter+2*wallWidth,separation, height]);
    
    for (i=[[0,0,0],[1,0,0]]) mirror(i) {
        translate([-holeSpacing/2, -separation/2-newH, height/2])
        rotate([-90,0,0]) {
            cylinder(r=screwDiameter/2, h=longScrewHeight, $fn=90);
        }
    }
    
    
    translate([-beltWidth/2+extraOffset,-beltToothHeight-separation,0]) {
        for(i=[0:beltPitch:height]) {
            hull() {
                translate([0,beltToothHeight-0.01,i])
                    cube([beltWidth,0.01,0.01]);
                translate([0,0,i+beltPitch])
                    cube([beltWidth,beltToothHeight,0.01]);
            }
        }
    }
    
}