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
cBeamWidth=40;

beltToothHeight = 1.5;

newH = vWheelHoleSeparation+plateHoleSideOffset+nema23Offset-smallBearingDiameter/2-wallThickness-beltToothHeight;

// inherited values

beltWidth = 10;

beltHeight = 6;

beltSection = 10;

screwDiameter = 5.5;

screwHeadDiameter = 10;

nutTrapWidth = 8;

nutTrapHeight = 3;

separation = 1;

beltPitch = 2;

wallWidth = 5;

holeSpacing = 20;

longScrewOffset = 15 - wallThickness-4;

secondaryScrewLen = 12;

extraOffset = 8;

topHeightThickness = 5;

height = 20;
mirror ([0,0,0]) {
    /*rotate([0,-90,0])*/ {
        difference() {
            union() {
                cube([cBeamWidth+2*wallThickness,2*wallThickness+screwHeadDiameter+extraOffset,newH ]);
                translate([0,0,newH+separation])
                    cube([holeSpacing+2*wallThickness,2*wallThickness,topHeightThickness]);
            }
            
            translate([wallThickness+screwDiameter,0,newH-separation]) {
                for(i=[0:beltPitch:(2*wallThickness+screwHeadDiameter+extraOffset)]) {
                    hull() {
                        translate([0,i,beltToothHeight-0.01])
                            cube([beltWidth,0.01,0.01]);
                        translate([0,i+beltPitch,0])
                            cube([beltWidth,0.01,beltToothHeight]);
                    }
                }
            }
            translate([wallThickness+screwHeadDiameter/2,wallThickness+extraOffset+screwHeadDiameter/2,0]) {
                cylinder(r=screwDiameter/2,h=newH+separation,$fn=90);
                translate([0,0,longScrewOffset]){
                    cylinder(r=screwHeadDiameter/2,h=newH+separation-longScrewOffset,$fn=90);
                }
            }
            translate([wallThickness+3*screwHeadDiameter/2+holeSpacing,wallThickness+extraOffset+screwHeadDiameter/2,0]) {
                cylinder(r=screwDiameter/2,h=newH+separation,$fn=90);
            }
            for (i=[wallThickness,wallThickness+holeSpacing]) {
                translate([i,wallThickness,0]) {
                    cylinder(r=screwDiameter/2,h=newH+topHeightThickness+separation,$fn=90);
                }
                translate([i-nutTrapWidth/2,0,newH+topHeightThickness+separation-secondaryScrewLen]) {
                    cube([nutTrapWidth,nutTrapWidth+wallThickness,nutTrapHeight]);
                }
            }
        }
    }
}

/*
    translate([wallThickness,0,newH-separation]) {
        for(i=[0:beltPitch:(2*wallThickness+screwHeadDiameter)]) {
            hull() {
                translate([0,i,beltToothHeight-0.01])
                    cube([beltWidth,0.01,0.01]);
                translate([0,i+beltPitch,0])
                    cube([beltWidth,0.01,beltToothHeight]);
            }
        }
    }
*/