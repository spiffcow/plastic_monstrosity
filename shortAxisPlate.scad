include<constants.scad>;
use<vslot.scad>;

nema23CenterDiameter = 39;
nema23ScrewHoleSeparation = 47.14;
nema23ScrewDiameter = 5;
nema23Offset = 10;

vWheelHoleSeparation = 5.95;
vWheelHoleDiameterLarge = 7.2;
vWheelHoleDiameterSmall = 5.1;
vWheelHoleScrewHeadDiameter = 10;
vWheelHoleSizeDiff = vWheelHoleDiameterLarge-vWheelHoleDiameterSmall;

wallThickness = 8;
plateHoleSideOffset = 11;

cBeamWidth = 80;
cBeamDepth = 40;
roundedEdgeDiameter = 10;

screwOffset = 5;

plateHeight = cBeamWidth + 2*vWheelHoleSeparation + 2*plateHoleSideOffset;
plateWidth = cBeamWidth+40;

setScrewHoleDiameter = 3;
setScrewNutWidth = 5.6;
setScrewNutHeight = 2.5;

maxHoleHeight = 100;
lowProfileHeadHeight = 3;

isFront = true;
vSlotScrewOffsets = [for(i=[0,3]) plateHoleSideOffset+vWheelHoleSeparation+10 + i*20 ];
   
vSlotScrewOffsets = [vWheelHoleSeparation+vWheelHoleDiameterSmall+vWheelHoleScrewHeadDiameter, plateHeight/2, plateHeight - (vWheelHoleSeparation+vWheelHoleDiameterSmall+vWheelHoleScrewHeadDiameter+vWheelHoleSizeDiff/2)];

vSlotScrewOffsetsBack = [plateHoleSideOffset,plateHeight-plateHoleSideOffset]; 

vSlotBackOffset = wallThickness;

difference() {
    union() {
        hull() {
            for (i=[-1,1], j=[-1,1]) {
                translate([i*(plateWidth/2-roundedEdgeDiameter/2), j*(plateHeight/2-roundedEdgeDiameter/2),0])
                    cylinder(h=wallThickness,r=roundedEdgeDiameter/2, $fn=90);
                translate([i*(nema23ScrewHoleSeparation/2+plateHoleSideOffset-roundedEdgeDiameter/2),plateHeight/2+nema23Offset+nema23ScrewHoleSeparation+plateHoleSideOffset-roundedEdgeDiameter/2,0]) 
                    cylinder(h=wallThickness,r=roundedEdgeDiameter/2, $fn=90);
            }
        }
        if (isFront) hull() {
            translate([-cBeamWidth/2-wallThickness,-plateHeight/2,vSlotBackOffset])
                cube([cBeamWidth+2*wallThickness,plateHeight,cBeamDepth]);
            for (i=[-1,1], j=[-1,1]) {
                translate([i*(plateWidth/2-roundedEdgeDiameter/2), j*(plateHeight/2-roundedEdgeDiameter/2),0])
                    cylinder(h=wallThickness,r=roundedEdgeDiameter/2, $fn=90);
            }
        }
    }

    for (i=[[0,0,0],[1,0,0]]) mirror(i) {
        translate([plateWidth/2 - plateHoleSideOffset, cBeamWidth/2 + vWheelHoleSeparation, 0]) {
            cylinder(h=maxHoleHeight,r=vWheelHoleDiameterSmall/2, $fn=90);
            translate([0,0,wallThickness])
                cylinder(h=maxHoleHeight,r=vWheelHoleScrewHeadDiameter/2, $fn=90);
        }
        translate([plateWidth/2 - plateHoleSideOffset, -cBeamWidth/2 - vWheelHoleSeparation+vWheelHoleSizeDiff/2, 0]) {
            hull() {
                cylinder(h=wallThickness,r=vWheelHoleDiameterSmall/2, $fn=90);
                translate([0,-vWheelHoleSizeDiff,0])
                    cylinder(h=maxHoleHeight,r=vWheelHoleDiameterSmall/2, $fn=90);
            }
            translate([0,0,wallThickness]) hull() {
                cylinder(h=maxHoleHeight,r=vWheelHoleScrewHeadDiameter/2, $fn=90);
                translate([0,-vWheelHoleSizeDiff,0])
                    cylinder(h=maxHoleHeight,r=vWheelHoleScrewHeadDiameter/2, $fn=90);
            }
            hull() {
                translate([0,-vWheelHoleSizeDiff,0])
                    cylinder(h=wallThickness,r=vWheelHoleDiameterSmall/2, $fn=90);
                translate([-setScrewNutWidth/2,-vWheelHoleSizeDiff-vWheelHoleDiameterSmall/2-setScrewNutHeight,0])
                    cube([setScrewNutWidth,setScrewNutHeight,wallThickness]);
            }
            translate([0,0,wallThickness/2]) rotate([90,0,0])
                cylinder(h=plateHoleSideOffset+vWheelHoleSizeDiff/2,r=setScrewHoleDiameter/2, $fn=90);
        }
            
    }
    
    // nema 23 opening
    translate([0,plateHeight/2+nema23Offset+nema23ScrewHoleSeparation/2,0]) {
        cylinder(r=nema23CenterDiameter/2,h=wallThickness, $fn=90);
        for (i=[-1,1], j=[-1,1]) {
            translate([i*nema23ScrewHoleSeparation/2,j*nema23ScrewHoleSeparation/2,0]) {
                cylinder(r=nema23ScrewDiameter/2,h=wallThickness, $fn=90);
                if (isFront) translate([0,0,wallThickness-lowProfileHeadHeight]) cylinder(r=vWheelHoleScrewHeadDiameter/2,h=lowProfileHeadHeight, $fn=90);
            }
        }
    }
    
    translate([-sectionCountWidth*profileSize,plateHeight/2,vSlotBackOffset])
        rotate([90,0,0])
            drawVslotExtrusion(
                plateWidth,
                sectionCountWidth=4, 
                sectionCountDepth= isFront ? 2 : 1, 
                topIndent=false, 
                rightIndent=true, 
                leftIndent=true, 
                bottomIndent=true, 
                screwOffset=screwOffset,
                leftScrewPoints = vSlotScrewOffsets,
                rightScrewPoints = vSlotScrewOffsets,
                topScrewPoints = vSlotScrewOffsetsBack,
                screwHeight=maxHoleHeight
            );
}
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