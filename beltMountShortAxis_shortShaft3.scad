include<constants.scad>;
use<vslot.scad>;

// external values
vWheelHoleSeparation = 5.95;
wallThickness = 9;
plateHoleSideOffset = 11;
nema23ScrewHoleSeparation = 47.14;
nema23ScrewDiameter = 5;
nema23Offset = 10;
smallBearingDiameter=16;
cBeamWidth=40;

beltToothHeight = 1.5;

newH = vWheelHoleSeparation+plateHoleSideOffset+nema23Offset-smallBearingDiameter/2-beltToothHeight;

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

holeSpacing = 20;

longScrewOffset = 12 -4;

secondaryScrewLen = 12;

extraOffset = 0;

topHeightThickness = 5;

wallThicknessH = 5;

offsetFromCbeam = 1;

height = 20;
for (m=[[0,0,0],[1,0,0]]) mirror (m) {
    translate([separation,0,0]) rotate([90,0,0]) {
        difference() {
            union() {
                cube([cBeamWidth+2*wallThickness,2*wallThicknessH+screwDiameter+extraOffset,newH ]);
                for (i=[0,wallThickness+cBeamWidth]) {
                    translate([i,0,-profileSize])
                        cube([wallThickness,2*wallThicknessH+screwDiameter+extraOffset,newH+profileSize]);
                }
                translate([0,0,newH+separation])
                    cube([beltWidth+offsetFromCbeam+2*wallThickness,2*wallThicknessH+screwDiameter,topHeightThickness]);
            }
            
            translate([wallThickness+offsetFromCbeam,0,newH-separation]) {
                for(i=[0:beltPitch:(2*wallThickness+screwHeadDiameter+extraOffset)]) {
                    hull() {
                        translate([0,i,beltToothHeight-0.01])
                            cube([beltWidth,0.01,0.01]);
                        translate([0,i+beltPitch,0])
                            cube([beltWidth,0.01,beltToothHeight]);
                    }
                }
            }
            translate([wallThickness+profileSize/2+holeSpacing,wallThicknessH+extraOffset+screwDiameter/2,0]) {
                cylinder(r=screwDiameter/2,h=newH+separation,$fn=90);
                translate([0,0,longScrewOffset]){
                    cylinder(r=screwHeadDiameter/2,h=newH+separation-longScrewOffset,$fn=90);
                }
            }
            for (i=[wallThickness+offsetFromCbeam-screwDiameter/2,wallThickness+beltWidth+offsetFromCbeam+screwDiameter/2]) {
                translate([i,wallThicknessH+screwDiameter/2,newH-secondaryScrewLen]) {
                    cylinder(r=screwDiameter/2,h=newH+topHeightThickness+separation,$fn=90);
                }
                translate([i-nutTrapWidth/2,0,newH+topHeightThickness+separation-secondaryScrewLen]) {
                    cube([nutTrapWidth,nutTrapWidth+wallThickness+screwDiameter/2,nutTrapHeight]);
                }
            }
            translate([wallThickness,wallThicknessH+screwDiameter/2,-profileSize/2]) rotate([0,-90,0]){
                cylinder(r=screwDiameter/2,h=newH+topHeightThickness+separation,$fn=90);
                translate([0,0,longScrewOffset]){
                    cylinder(r=screwHeadDiameter/2,h=newH+separation-longScrewOffset,$fn=90);
                }
            }
            translate([wallThickness+cBeamWidth,wallThicknessH+screwDiameter/2,-profileSize/2]) rotate([0,90,0]){
                cylinder(r=screwDiameter/2,h=newH+topHeightThickness+separation,$fn=90);
                translate([0,0,longScrewOffset]){
                    cylinder(r=screwHeadDiameter/2,h=newH+separation-longScrewOffset,$fn=90);
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