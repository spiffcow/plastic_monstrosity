include<constants.scad>;
use<vslot.scad>;

// diameter of the tube (mm)
tubeDiameter = 20.4; 

// hole size of the bearing (mm)
bearingHoleDiameter = 8;

// bearing diameter (mm)
bearingDiameter = 22;

// bearing width (mm)
bearingWidth = 7;

// bearing collar thickness (mm)
bearingCollarThickness = 2;

// minimum thickness of the walls (mm)
wallThickness = 12.5;

// minimum height of the walls (mm)
wallHeight = 55;

// the space between the bearing and the wall (mm)
tolerance = 2;

// the space between the tube and the wall (mm)
tubeTolerance = 2;

// determines beefiness of edge extensions
beefiness = 10;//9;

vslotScrewDiameter = 5;

vslotScrewHeadDiameter = 10;

vslotWallWidth=7;

vslotScrewOffset = 1;

beltWidth = 14;

beltHeight = 6;

motorMountWidth = 70;

// 688 bearing
smallBearingDiameter = 16; 
smallBearingBore = 5;
smallBearingWidth = 8;

nema23CenterDiameter = 39;
nema23ScrewHoleSeparation = 47.14;
nema23ScrewDiameter = 5;
nema23Offset = 80;
nema23CutoutHeight = 200;
centerWidth = 2 * wallThickness + bearingWidth + 2*tolerance;
sidePanelThickness = (centerWidth-2*smallBearingWidth-2*tolerance)/2;//8;//wallThickness+tolerance+bearingWidth/2 - beltWidth/2;
echo("spacing (assuming 1500mm c beam)");
echo(1500 - centerWidth+2*sidePanelThickness); 

nema23BearingOffset = centerWidth/2-smallBearingWidth;

lowerNema23SpacerLength = 2*smallBearingWidth+2*tolerance;
upperNema23SpacerLength = beltWidth;


module Outer() {
translate([bearingWidth/2,tubeDiameter/2+bearingDiameter/2,0])
    rotate([0,90,0]) union() {
        hull() {
                cylinder(r=bearingHoleDiameter/2+bearingCollarThickness,h=0.01,$fn=90);
                translate([0,0,tolerance])
                    cylinder(r=bearingHoleDiameter/2+bearingCollarThickness+tolerance,h=0.01,$fn=90);
        }
        translate([-bearingDiameter/2,-bearingDiameter/2-wallThickness,tolerance])
            cube([bearingDiameter+wallHeight,bearingDiameter+wallThickness+2*tolerance,wallThickness]);
        hull() {
                translate([0,0,2*tolerance+wallThickness])
                    cylinder(r=bearingHoleDiameter/2+bearingCollarThickness,h=0.01,$fn=90);
                translate([0,0,tolerance+wallThickness])
                    cylinder(r=bearingHoleDiameter/2+bearingCollarThickness+tolerance,h=0.01,$fn=90);
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
        cylinder(r=tubeDiameter/2,h=500, center=true, $fn=90); 
}

testFit = false;

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
                Outer();
                rotate([0,0,-120]) mirror([1,0,0]) Outer();
                translate([sin(60)*(tubeDiameter/2-wallThickness/2),cos(60)*(tubeDiameter/2-wallThickness/2),-bearingDiameter/2-wallHeight]) {
                    hull() {
                        translate([0,tubeDiameter/2+beefiness-wallThickness,0])
                            cylinder(r=0.01,h=bearingDiameter+wallHeight, $fn=90);
                        rotate([0,0,-120]) {
                            translate([0,tubeDiameter/2+beefiness-wallThickness,0]) 
                                cylinder(r=0.01,h=bearingDiameter+wallHeight, $fn=90);
                        }
                        cylinder(r=0.01,h=bearingDiameter+wallHeight, $fn=90);
                    }
                }
                translate([-wallThickness-tolerance-bearingWidth/2,tubeDiameter/2+bearingDiameter+tolerance,-(bearingDiameter+2*wallHeight)/2])
                    cube([2*wallThickness+2*tolerance+bearingWidth,wallThickness,bearingDiameter+wallHeight]);
            }
            cylinder(r=tubeDiameter/2+tubeTolerance,h=bearingDiameter+2*wallThickness, center=true, $fn=90);
            Inner();
            rotate([0,0,-120]) mirror([1,0,0]) Inner();
        }
    }
}

module Nema23Opening()
{
    cylinder(r=nema23CenterDiameter/2, h=nema23CutoutHeight, $fn=90);
    difference() {
        hull() {
            translate([0, 0, nema23BearingOffset-tolerance])
                cylinder(r=nema23CenterDiameter/2, h=2*smallBearingWidth+2*tolerance, $fn=90);
            translate([-nema23ScrewHoleSeparation/2-smallBearingDiameter/2-tolerance,-nema23ScrewHoleSeparation/2-smallBearingDiameter/2-tolerance,nema23BearingOffset-tolerance])
            cube([nema23ScrewHoleSeparation+smallBearingDiameter+2*tolerance,smallBearingDiameter+2*tolerance,2*smallBearingWidth+2*tolerance]);
        }/*
        for (i=[-1,1], j=[-1]) {
            translate([i*nema23ScrewHoleSeparation/2, j*nema23ScrewHoleSeparation/2, nema23BearingOffset-tolerance]) {
                hull() {
                    cylinder(r=smallBearingBore/2+1, h=tolerance, $fn=90);
                    cylinder(r=smallBearingBore/2+bearingCollarThickness, h=0.01, $fn=90);
                }
                hull() {
                    translate([0,0,tolerance+2*smallBearingWidth+tolerance-0.01]) cylinder(r=smallBearingBore/2+bearingCollarThickness, h=tolerance, $fn=90);
                    translate([0,0,tolerance+2*smallBearingWidth]) cylinder(r=smallBearingBore/2+1, h=tolerance, $fn=90);
                }
            }
        }*/
    }
    for (i=[-1,1], j=[-1,1]) {
        translate([i*nema23ScrewHoleSeparation/2, j*nema23ScrewHoleSeparation/2, 0])
            cylinder(r=nema23ScrewDiameter/2, h=nema23CutoutHeight, $fn=90);
    }
    if (testFit)
    {
        color("red", 0.5) for (i=[-1,1], j=[-1]) {
            translate([i*nema23ScrewHoleSeparation/2, j*nema23ScrewHoleSeparation/2, nema23BearingOffset-tolerance])
                cylinder(r=smallBearingDiameter/2, h=2*smallBearingWidth+2*tolerance, $fn=90);
        }
    }
}
//translate([200,0,0]) rotate([0,90,0]) Nema23Opening();

module Nema23Spacers() {
    for (i=[-1,1])
        translate([2*i*nema23ScrewDiameter,-2*nema23ScrewDiameter,0])
            difference() {
                cylinder(r=nema23ScrewDiameter,h=lowerNema23SpacerLength,$fn=90);
                cylinder(r=nema23ScrewDiameter/2,h=lowerNema23SpacerLength,$fn=90);
            }
    for (i=[-1,1])
        translate([2*i*nema23ScrewDiameter,2*nema23ScrewDiameter,0])
            difference() {
                cylinder(r=nema23ScrewDiameter,h=upperNema23SpacerLength,$fn=90);
                cylinder(r=nema23ScrewDiameter/2,h=upperNema23SpacerLength,$fn=90);
            }
}
//translate([-200,0,0]) Nema23Spacers();


vslotHeight = 50;//2*wallThickness+2*tolerance+bearingWidth-vslotWallWidth;
screwOffsets = [vslotWallWidth+vslotScrewHeadDiameter/2, vslotHeight-(vslotWallWidth+vslotScrewHeadDiameter/2)];

mvector = [0,0,0];

rotate([180,0,0]) mirror(mvector) difference() {
    union() {
        Roller();
        translate([0,0,-2*wallHeight - 1/2*bearingDiameter])
            rotate([0,180,0])
                Roller();
        translate([-(2*wallThickness+2*tolerance+bearingWidth)/2+vslotWallWidth,tubeDiameter/2+bearingDiameter+beltHeight+vslotWallWidth-wallWidth,bearingDiameter/2-vslotWallWidth]) {
            difference() {
                union() {
                    translate([-vslotWallWidth,0,-2*sectionWidth-vslotWallWidth]) 
                        cube([vslotHeight+vslotWallWidth,4*sectionWidth+2*vslotWallWidth,2*sectionWidth+2*vslotWallWidth]);
                    
                    hull() {
                        translate([-vslotWallWidth,0,vslotWallWidth-2*wallHeight - 1.5*bearingDiameter])
                            cube([sidePanelThickness,1,2*wallHeight + 1.5*bearingDiameter]);
                        translate([-vslotWallWidth,0,vslotWallWidth-1.5*bearingDiameter-nema23Offset-nema23ScrewDiameter])
                            cube([sidePanelThickness,4*sectionWidth+2*vslotWallWidth,nema23Offset+nema23ScrewDiameter]);
                    }
                    hull() {
                        translate([-vslotWallWidth + 2*wallThickness + bearingDiameter-sidePanelThickness-(wallThickness+tolerance+bearingWidth/2 - beltWidth/2),0,vslotWallWidth-2*wallHeight - 1.5*bearingDiameter])
                            cube([sidePanelThickness,1,2*wallHeight + 1.5*bearingDiameter]);
                        translate([-vslotWallWidth + 2*wallThickness + bearingDiameter-sidePanelThickness-(wallThickness+tolerance+bearingWidth/2 - beltWidth/2),0,vslotWallWidth-1.5*bearingDiameter-nema23Offset-nema23ScrewDiameter])
                            cube([sidePanelThickness,4*sectionWidth+2*vslotWallWidth,nema23Offset+nema23ScrewDiameter]);
                    }
                }
                translate([0,vslotWallWidth,0])
                    rotate([0,90,0])
                        drawVslotExtrusion(
                                vslotHeight,
                                sectionCountWidth=2, 
                                sectionCountDepth=4, 
                                topIndent=true, 
                                rightIndent=true, 
                                leftIndent=true, 
                                bottomIndent=true, 
                                screwOffset=8,
                                leftScrewPoints = screwOffsets,
                                rightScrewPoints = screwOffsets,
                                //topScrewPoints = screwOffsets
                                bottomScrewPoints = screwOffsets,
                                screwHeight=30,
                                backScrewPoints = [profileSize/2, profileSize*3/2,profileSize*5/2,profileSize*7/2]
                        );
            }
        }
    }
    translate([-beltWidth/2,tubeDiameter/2+bearingDiameter,-2*(wallHeight+bearingDiameter+tolerance)])
        cube([beltWidth,beltHeight,2*(wallHeight+1.5*bearingDiameter)]);
    
    translate([-wallThickness-bearingWidth/2-tolerance,tubeDiameter/2+bearingDiameter+smallBearingDiameter/2+nema23ScrewHoleSeparation/2+beltHeight+tolerance-0.01,-nema23Offset])
        rotate([0,90,0]) 
            Nema23Opening();
    cylinder(r=tubeDiameter/2+tubeTolerance,h=500, center=true, $fn=90); 
}

