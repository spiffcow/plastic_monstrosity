include<constants.scad>;
use<vslot.scad>;

vWheelHoleSeparation = 5.95;
vWheelHoleDiameterLarge = 7.2;
vWheelHoleDiameterSmall = 5.1;
vWheelHoleScrewHeadDiameter = 10;
//vWheelHoleScrewHeadHeight = 5; // Chinese spindle
vWheelHoleScrewHeadHeight = 5; // Makita
vWheelHoleSizeDiff = vWheelHoleDiameterLarge-vWheelHoleDiameterSmall;
vWheelHoleFromCenter= 14.25;

wallThickness = 8;
plateHoleSideOffset = 8;

cBeamWidth = 80;
cBeamInnerWidth = 40;
cBeamDepth = 40;
roundedEdgeDiameter = 10;

screwOffset = 5;

plateHeight = 80;
plateWidth = 65;

setScrewHoleDiameter = 3;
setScrewNutWidth = 6;
setScrewNutHeight = 3;
setScrewHeadWidth = 6;
setScrewWallThickness = 5;
setScrewMaxLength = 12;

vSlotScrewOffsets = [for(i=[0,3]) plateHoleSideOffset+vWheelHoleSeparation+10 + i*20 ];
   
vSlotScrewOffsets = [vWheelHoleSeparation+vWheelHoleDiameterSmall+vWheelHoleScrewHeadDiameter, plateHeight/2, plateHeight - (vWheelHoleSeparation+vWheelHoleDiameterSmall+vWheelHoleScrewHeadDiameter+vWheelHoleSizeDiff/2)];

vSlotScrewOffsetsBack = [plateHoleSideOffset,plateHeight-plateHoleSideOffset]; 

vSlotBackOffset = 6;

//spindleDiameter = 65; // Makita compact router
//spindleDiameter = 2.7 * 25.4; // DWP 611 
//spindleDiameter = 52; // Chinese spindle 
defaultSpindleDiameter = 80; // VFD spindle
spindleWallWidth = 5;
spindleScrewSize = 5;
spindleScrewHeadSize = 10;
spindlenutTrapWidth = 8;
spindlenutTrapHeight = 3;
spindleSeparation = 2;
spindleHoleOffset = 12;

leadScrewHoleSize = 5;
leadScrewHeadSize = 10;
leadScrewHoleOffsets = [
    [-10,10,0],
    [10,10,0],
    [-10,0,0],
    [10,0,0],
    [0,-10,0]
];
leadScrewLongHoleOffsets = [[0,0,0],[0,10,0]];

module ZAxis(spindleDiameter=defaultSpindleDiameter) 
{
    maxHoleHeight = spindleDiameter/2 + max([vWheelHoleScrewHeadHeight,spindleWallWidth]);
    spindleLockZOffset = wallThickness + spindleWallWidth + max([vWheelHoleScrewHeadHeight,spindleWallWidth]) + spindleDiameter;
    rotate([-90,0,0]) difference() {
        union() {
            hull() {
                translate([-plateWidth/2, -plateHeight/2,0])
                    cube([plateWidth,plateHeight,wallThickness]);
                translate([0,plateHeight/2,wallThickness + max([vWheelHoleScrewHeadHeight,spindleWallWidth]) + spindleDiameter/2]) {
                    rotate([90,0,0])
                        cylinder(h=plateHeight,r=spindleDiameter/2+spindleWallWidth,$fn=90);
                }
                translate([-spindleSeparation/2-spindleWallWidth,-plateHeight/2,spindleLockZOffset]) {
                    cube([spindleSeparation+3*spindleWallWidth+spindlenutTrapHeight,plateHeight,spindleScrewSize+spindleWallWidth]);
                }
            }
        }

        for (i=[[0,0,0],[0,1,0]]) mirror(i) {
            translate([-vWheelHoleFromCenter, plateHeight/2 - plateHoleSideOffset, 0]) {
                cylinder(h=maxHoleHeight,r=vWheelHoleDiameterSmall/2, $fn=90);
                translate([0,0,wallThickness])
                    cylinder(h=maxHoleHeight,r=vWheelHoleScrewHeadDiameter/2, $fn=90);
            }
            translate([vWheelHoleFromCenter, plateHeight/2 - plateHoleSideOffset, 0]) {
                hull() {
                    cylinder(h=wallThickness,r=vWheelHoleDiameterSmall/2, $fn=90);
                    translate([vWheelHoleSizeDiff,0,0])
                        cylinder(h=maxHoleHeight,r=vWheelHoleDiameterSmall/2, $fn=90);
                }
                translate([0,0,wallThickness]) hull() {
                    cylinder(h=maxHoleHeight,r=vWheelHoleScrewHeadDiameter/2, $fn=90);
                    translate([vWheelHoleSizeDiff,0,0])
                        cylinder(h=maxHoleHeight,r=vWheelHoleScrewHeadDiameter/2, $fn=90);
                }
                translate([-vWheelHoleSizeDiff-vWheelHoleDiameterSmall/2,-setScrewNutWidth/2,0])
                    cube([setScrewNutHeight,setScrewNutWidth,wallThickness/2+setScrewNutWidth/2]);
                translate([0,0,wallThickness/2]) rotate([0,-90,0]) 
                    cylinder(h=vWheelHoleSizeDiff+vWheelHoleDiameterSmall/2+setScrewWallThickness,r=setScrewHoleDiameter/2, $fn=90);
                hull() {                
                    translate([-vWheelHoleSizeDiff-vWheelHoleDiameterSmall/2-setScrewWallThickness,0,wallThickness/2]) rotate([0,-90,0]) 
                        cylinder(h=setScrewMaxLength,r=setScrewHeadWidth/2, $fn=90);
                    translate([-vWheelHoleSizeDiff-vWheelHoleDiameterSmall/2-setScrewWallThickness,0,0]) rotate([0,-90,0]) 
                        cylinder(h=setScrewMaxLength,r=setScrewHeadWidth/2, $fn=90);
                }
            }
            translate([0,-plateHeight/2 + spindleHoleOffset,spindleLockZOffset]) {
                translate([-spindleSeparation/2-spindleWallWidth,0,spindleScrewSize/2]){
                    rotate([0,-90,0]) cylinder(h=maxHoleHeight,r=spindleScrewHeadSize/2,$fn=90);
                    rotate([0,90,0]) cylinder(h=maxHoleHeight,r=spindleScrewSize/2,$fn=90);
                }
                translate([spindleSeparation/2+spindleWallWidth,-spindlenutTrapWidth/2,-spindlenutTrapWidth/2]){
                    cube([spindlenutTrapHeight,spindlenutTrapWidth,maxHoleHeight]);
                }
            }
            
            translate([0,plateHeight/2,wallThickness + max([vWheelHoleScrewHeadHeight,spindleWallWidth]) + spindleDiameter/2]) {
                rotate([90,0,0])
                    cylinder(h=plateHeight,r=spindleDiameter/2,$fn=90);
            } 
            translate([-spindleSeparation/2,0,spindleLockZOffset-spindleWallWidth]) {
                cube([spindleSeparation,plateHeight,spindleLockZOffset]);
            }   
        }
        

        hull() {
            for (x=leadScrewHoleOffsets) translate([0,0,wallThickness]) translate(x) 
                cylinder(h=maxHoleHeight,r=leadScrewHeadSize/2,$fn=90);
        }
        for (x=leadScrewHoleOffsets) {
            translate(x) cylinder(h=maxHoleHeight,r=leadScrewHoleSize/2,$fn=90);
        }
        hull() {
            for (x=leadScrewLongHoleOffsets) translate(x) 
                cylinder(h=maxHoleHeight,r=leadScrewHoleSize/2,$fn=90);
        }
    }
}

ZAxis();
/*
        translate([-sectionCountWidth*profileSize,plateHeight/2,vSlotBackOffset])
            rotate([90,0,0])
                drawVslotExtrusion(
                    plateWidth,
                    sectionCountWidth=4, 
                    sectionCountDepth=2, 
                    topIndent=false, 
                    rightIndent=true, 
                    leftIndent=true, 
                    bottomIndent=true, 
                    screwOffset=8,
                    //leftScrewPoints = vSlotScrewOffsets,
                    //rightScrewPoints = vSlotScrewOffsets,
                    //topScrewPoints = screwOffsets
                    topScrewPoints = vSlotScrewOffsets,
                    screwHeight=maxHoleHeight
                );
*/